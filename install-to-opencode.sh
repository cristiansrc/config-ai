#!/bin/bash

# Script de Instalación / Sincronización hacia OpenCode
# Copia los agentes y skills activos del repositorio hacia el directorio de configuración de OpenCode.

BASE_DIR="/home/cristiansrc/Documentos/Proyectos/config-ai"
ACTIVE_DIR="$BASE_DIR/active/opencode"
TARGET_DIR="/home/cristiansrc/.config/opencode"

echo "--- Iniciando Instalación de Agentes y Skills en OpenCode ---"

# Asegurar que existan los directorios destino
mkdir -p "$TARGET_DIR/agents"
mkdir -p "$TARGET_DIR/skills"

# Sincronizar Agentes desde el Repositorio hacia OpenCode
echo "Instalando agentes..."
rsync -av --delete "$ACTIVE_DIR/agents/" "$TARGET_DIR/agents/" --exclude 'backup-*'

# Sincronizar Skills desde el Repositorio hacia OpenCode (siguiendo enlaces si existieran)
echo "Instalando skills..."
rsync -avL --delete "$ACTIVE_DIR/skills/" "$TARGET_DIR/skills/" --exclude 'backup-*'

echo "--- Instalación Completada con Éxito ---"
