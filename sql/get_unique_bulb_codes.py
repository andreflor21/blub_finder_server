texto = """
"H15;"
"H7;"
"H1;9005;"
"9005;9004;"
"""

# Extração dos modelos distintos de lâmpadas
def extrair_modelos_distintos(texto):
    linhas = texto.splitlines()
    modelos = set()

    for linha in linhas:
        linha = linha.replace('"', '').strip()
        if linha:
            partes = linha.split(';')
            for parte in partes:
                if parte:
                    modelos.add(parte)
    
    return sorted(modelos)

modelos_distintos = extrair_modelos_distintos(texto)
print(modelos_distintos)