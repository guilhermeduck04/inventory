Config = {}

-- Configuração de Líderes
-- [NomeDoCargoLider] = "NomeDoCargoBaseParaVigiar"
Config.Lideres = {
    ["Delegado"] = "Civil",
    ["Coronel"] = "Policia", -- Exemplo, pode adicionar mais
    ["Diretor"] = "Hospital",
    ["LiderMecanico"] = "Mecanico",
}

-- Locais de Ponto
Config.Locais = {
    { 474.47, -1000.69, 30.46, "DEPARTAMENTO DE POLÍCIA" },
    { -681.56, 328.8, 83.09, "HOSPITAL CENTRAL" },
    { -347.11, -133.32, 39.01, "MECÂNICA LSC" },
}

-- Exceções (Job <-> Paisana)
Config.Excecoes = {
    ["LiderMecanico"] = "PaisanaMecanicoLider",
    ["PaisanaMecanicoLider"] = "LiderMecanico",
    -- ["Delegado"] = "PaisanaDelegado",
    -- ["PaisanaDelegado"] = "Delegado",
}

-- CONFIGURAÇÃO DE BLIPS (GPS)
-- Tipos de Blip: 1 (Círculo/Bolinha), 225 (Carro), etc.
-- Cores: 3 (Azul), 1 (Vermelho), 2 (Verde), 39 (Cinza), etc.
Config.Blips = {
    -- Policia Civil (Bolinha Cinza)
    ["Civil"] = { group = "Civil", blipColor = 39, blipId = 1, name = "Policial Civil" },  
    
    -- Policia Militar (Bolinha Azul) - Exemplo, ajuste o nome do grupo se for diferente
    ["PoliciaMilitar"] = { group = "Policia", blipColor = 3, blipId = 1, name = "Policial Militar" },

    -- Mecanica (Bolinha Verde)
    ["Mecanico"] = { group = "Mecanico", blipColor = 2, blipId = 1, name = "Mecânico" },
    ["LiderMecanico"] = { group = "Mecanico", blipColor = 2, blipId = 1, name = "Líder Mecânico" },

    -- Hospital (Bolinha Vermelha)
    ["Hospital"] = { group = "Hospital", blipColor = 1, blipId = 1, name = "Médico" },
    ["DiretorHospital"] = { group = "Hospital", blipColor = 1, blipId = 1, name = "Diretor" },
}