#!/bin/bash
# Git Hook: pre-push (Protección de Ramas Local en Base a Estados SDD)
#
# Este script evita empujar cambios a ramas protegidas locales/remotas (develop, qa, master)
# si el incremento de la especificación SDD no ha sido aprobado formalmente por el humano
# en el Shared Context.
#
# Instalar en el repositorio con:
# cp pre-push-hook-template.sh .git/hooks/pre-push && chmod +x .git/hooks/pre-push

remote="$1"
url="$2"

# Leer entrada estándar de Git (lista de referencias que se van a hacer push)
# Formato: <local ref> <local sha> <remote ref> <remote sha>
while read local_ref local_sha remote_ref remote_sha
do
    # Detectar la rama remota destino
    remote_branch=$(echo "$remote_ref" | sed 's/refs\/heads\///')

    # Solo proteger ramas estables
    if [[ "$remote_branch" == "develop" || "$remote_branch" == "qa" || "$remote_branch" == "master" || "$remote_branch" == "main" ]]; then
        echo "=========================================="
        echo "🔍 [Git Guard] Verificando estados de SDLC-IA para la rama: $remote_branch"

        # Obtener el nombre de la rama local activa
        local_branch=$(git symbolic-ref --short HEAD)

        # Extraer el nombre del incremento a partir de la rama feature/
        if [[ "$local_branch" =~ ^feature/(.+) ]]; then
            increment_name="${BASH_REMATCH[1]}"
        else
            echo "❌ Error: Debes empujar desde una rama 'feature/<increment-name>'."
            exit 1
        fi

        # Buscar el archivo del Shared Context
        context_file="docs/specs/.working/${increment_name}-sdd-context.md"

        if [ ! -f "$context_file" ]; then
            # Si el proyecto usa contexto alternativo o Standalone, buscar en docs/specs/
            context_file="docs/specs/${increment_name}-sdd-context.md"
        fi

        if [ ! -f "$context_file" ]; then
            echo "❌ Error: No se encontró el Shared Context en '$context_file'."
            echo "   Es obligatorio que exista la especificación para el incremento '$increment_name'."
            exit 1
        fi

        # 1. Validar la firma humana del QA para empujar a develop o ramas superiores
        if ! grep -q "## Human QA Approval: approved_by_user" "$context_file"; then
            echo "❌ PUSH ABORTADO: Falta la aprobación humana de QA."
            echo "   Debes verificar los cambios funcionalmente y añadir la siguiente firma en:"
            echo "   👉 $context_file"
            echo "   Línea exacta requerida:"
            echo "   ## Human QA Approval: approved_by_user"
            echo "=========================================="
            exit 1
        fi

        # 2. Validar que el estado del incremento no haya sido corrompido o manualizado
        # (El estado debe estar en 'quality-approved' o 'implemented')
        if ! grep -q "Current status:.*\(quality-approved\|implemented\|closed\)" "$context_file"; then
            echo "❌ PUSH ABORTADO: El estado de la especificación no es apto para despliegue."
            echo "   El estado actual debe ser 'quality-approved' o superior y estar verificado por final-validation."
            echo "   Por favor, ejecuta las validaciones correspondientes primero."
            echo "=========================================="
            exit 1
        fi

        echo "✅ [Git Guard] Validación exitosa. Permitiendo push a $remote_branch."
        echo "=========================================="
    fi
done

exit 0
