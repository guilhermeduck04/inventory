# Plano B (Token de arma de serviço)

## Configuração da arma do token
* A tabela configurável fica em `zr_arsenal/server.lua` na constante `DUTY_WEAPONS`.
* Para adicionar novas armas, inclua um novo item no array com `token` e `weapon`.

## Geração de serial
* O serial é gerado **server-side** em `zr_arsenal/server.lua` na função `generateSerial`.
* O formato usa `timestamp + source + rand` conforme `DT-<timestamp>-<source>-<rand>`.

## Eventos de duty ON/OFF
* Duty ON: `ghost_ponto/server.lua` chama `zr_arsenal:issueDutyTokens` ao bater ponto.
* Duty OFF: `ghost_ponto/server.lua` chama `zr_arsenal:clearDutyTokens` ao sair de serviço.

## Handlers do inventário interceptados
Os seguintes fluxos bloqueiam transferência do token (evapora e remove arma):
* `src.droparItem` (drop no chão).
* `src.sendItem` (enviar para outro jogador).
* `src.colocarVehicle` (porta-malas).
* `src.colocarOrgChest` (baú de organização).
* `src.colocarHousehest` (baú de casa).
* `src.retirarItemRevistar` (revistar/saquear outro jogador).

## Observações
* O token é validado e equipado via evento `zr_arsenal:equipToken` (server), disparado pelo uso do item no inventário.
* Logs são emitidos com o prefixo `[DUTY-WEAPON]`.
