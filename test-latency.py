#!/usr/bin/env python3
import time
import subprocess
import json

# Lista de modelos configurados en el ecosistema config-ai para OpenCode
MODELS_TO_TEST = [
    "opencode-go/qwen3.7-plus",
    "opencode-go/qwen3.6-plus",
    "opencode-go/deepseek-v4-pro",
    "google/gemini-3.1-pro-preview",
    "opencode-go/deepseek-v4-flash"
]

def test_model(model_name):
    print(f"Probando {model_name}...")
    prompt = "Responde únicamente con la palabra 'OK'."
    
    # Construcción del comando opencode para testing en CLI
    cmd = ["opencode", "run", "--model", model_name, prompt]
    
    start_time = time.time()
    try:
        process = subprocess.run(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            timeout=15
        )
        latency = time.time() - start_time
        
        if process.returncode == 0 and "OK" in process.stdout:
            print(f"  🟢 Disponible | Latencia: {latency:.2f}s")
            return {"model": model_name, "status": "ONLINE", "latency": f"{latency:.2f}s"}
        else:
            error_msg = process.stderr.strip() or process.stdout.strip()
            print(f"  🔴 Error de Respuesta | Detalles: {error_msg[:60]}")
            return {"model": model_name, "status": "ERROR", "error": error_msg[:100]}
            
    except subprocess.TimeoutExpired:
        print("  ⏳ Timeout excedido (15s)")
        return {"model": model_name, "status": "TIMEOUT", "error": "Exceeded 15s"}
    except Exception as e:
        print(f"  🔴 No disponible | Error: {str(e)}")
        return {"model": model_name, "status": "OFFLINE", "error": str(e)}

if __name__ == "__main__":
    print("=== TEST DE DISPONIBILIDAD Y LATENCIA DE MODELOS ===")
    results = []
    for model in MODELS_TO_TEST:
        res = test_model(model)
        results.append(res)
        print("-" * 50)
        
    print("\n=== Resumen ===")
    print(json.dumps(results, indent=2))
