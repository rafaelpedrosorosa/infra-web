#!/bin/bash
# Script simples para validar registros DNS relacionados
# à entrega de e-mails (SPF, DKIM, DMARC e PTR).
#
# Desenvolvido para o desafio técnico.

DOMAIN="$1"

if [ -z "$DOMAIN" ]; then
    echo "Uso: $0 dominio.com"
    exit 1
fi

if ! command -v dig >/dev/null 2>&1; then
    echo "Erro: comando dig não encontrado."
    echo "Instale com: sudo apt install dnsutils"
    exit 1
fi

echo "========================================"
echo "Verificação de e-mail para: $DOMAIN"
echo "========================================"

echo
echo "1. SPF"
SPF=$(dig +short TXT "$DOMAIN" | grep "v=spf1")

if [ -n "$SPF" ]; then
    echo "[OK] SPF encontrado:"
    echo "$SPF"
else
    echo "[AUSENTE] SPF não encontrado."
fi

echo
echo "2. DKIM"
DKIM=$(dig +short TXT "default._domainkey.$DOMAIN")

if [ -n "$DKIM" ]; then
    echo "[OK] DKIM encontrado:"
    echo "$DKIM"
else
    echo "[AVISO] DKIM não encontrado com o seletor default."
    echo "O domínio pode utilizar outro seletor."
fi

echo
echo "3. DMARC"
DMARC=$(dig +short TXT "_dmarc.$DOMAIN")

if [ -n "$DMARC" ]; then
    echo "[OK] DMARC encontrado:"
    echo "$DMARC"
else
    echo "[AUSENTE] DMARC não encontrado."
fi

echo
echo "4. PTR / DNS reverso"
IP=$(dig +short A "$DOMAIN" | head -n 1)

if [ -z "$IP" ]; then
    echo "[ERRO] Não foi possível localizar um IPv4."
else
    echo "IP encontrado: $IP"

    PTR=$(dig +short -x "$IP")

    if [ -n "$PTR" ]; then
        echo "[OK] PTR encontrado:"
        echo "$PTR"
    else
        echo "[AUSENTE] PTR não encontrado para $IP."
    fi
fi

echo
echo "========================================"
echo "Verificação concluída."
echo "========================================"
