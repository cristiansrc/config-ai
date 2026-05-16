#!/bin/bash

# Script de Sincronizacion y Backup IA (Nueva Estructura)
# Mantiene la paridad de agentes/skills y aplica politica de 25 backups.

BASE_DIR="/home/cristiansrc/Documentos/config-ai"
ACTIVE_DIR="$BASE_DIR/active"
ARCHIVE_DIR="$BASE_DIR/archive/snapshots"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Asegurar que existan los directorios
mkdir -p "$ARCHIVE_DIR"
mkdir -p "$ACTIVE_DIR/gemini/agents"
mkdir -p "$ACTIVE_DIR/gemini/skills"
mkdir -p "$ACTIVE_DIR/opencode"

echo "--- Iniciando Sincronizacion y Backup (25 Retenciones) ---"

# 1. Realizar Backup de estado actual antes de sincronizar
echo "Generando snapshot en $ARCHIVE_DIR..."
tar -czf "$ARCHIVE_DIR/full-config-bk-$TIMESTAMP.tar.gz" -C "$ACTIVE_DIR" gemini opencode 2>/dev/null

# 2. Sincronizar desde OpenCode (Source of Truth) hacia Active
echo "Sincronizando desde configuraciones activas del sistema..."
# Sincronizar Agentes de OpenCode
rsync -av --delete "/home/cristiansrc/.config/opencode/agents/" "$ACTIVE_DIR/opencode/agents/" --exclude 'backup-*'
# Sincronizar Skills de OpenCode
rsync -avL --delete "/home/cristiansrc/.config/opencode/skills/" "$ACTIVE_DIR/opencode/skills/" --exclude 'backup-*'

# 3. Mantener paridad con Gemini (Opcional, según flujo)
# rsync -av --delete "$ACTIVE_DIR/opencode/skills/" "$ACTIVE_DIR/gemini/skills/"

# 4. Limpieza de backups antiguos (Mantener últimos 25)
echo "Aplicando política de retención: eliminando snapshots excedentes..."
ls -1tr "$ARCHIVE_DIR/"*.tar.gz | head -n -25 | xargs -r rm

echo "--- Proceso Finalizado con Éxito ---"
