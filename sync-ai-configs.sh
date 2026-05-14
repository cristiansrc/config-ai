#!/bin/bash

# Script de Sincronizacion y Backup IA (OpenCode -> Gemini)
# Mantiene la paridad de agentes/skills y aplica politica de 25 backups.

BASE_DIR="/home/cristiansrc/Documentos/config-ai"
OP_AGENTS="$BASE_DIR/opencode/agents"
OP_SKILLS="$BASE_DIR/opencode/skills"
GE_AGENTS="$BASE_DIR/gemini/agents"
GE_SKILLS="$BASE_DIR/gemini/skills"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

echo "--- Iniciando Sincronizacion ---"

# 1. Crear directorios de backup si no existen
mkdir -p "$BASE_DIR/opencode/backups"
mkdir -p "$BASE_DIR/gemini/backups"

# 2. Realizar Backup de estado actual
echo "Realizando backups..."
tar -czf "$BASE_DIR/opencode/backups/opencode-bk-$TIMESTAMP.tar.gz" -C "$BASE_DIR/opencode" agents skills 2>/dev/null
tar -czf "$BASE_DIR/gemini/backups/gemini-bk-$TIMESTAMP.tar.gz" -C "$BASE_DIR/gemini" agents skills 2>/dev/null

# 3. Sincronizar Skills (OpenCode -> Gemini)
echo "Sincronizando skills..."
# Usamos -L para copiar el contenido de los symlinks
rsync -avL --delete --exclude 'backup-*' "/home/cristiansrc/.config/opencode/skills/" "$GE_SKILLS/"

# 4. Limpieza de backups (Mantener ultimos 25)
echo "Limpiando backups antiguos (max 25)..."
ls -1tr "$BASE_DIR/opencode/backups/"*.tar.gz | head -n -25 | xargs -r rm
ls -1tr "$BASE_DIR/gemini/backups/"*.tar.gz | head -n -25 | xargs -r rm

echo "--- Sincronizacion Finalizada ---"
