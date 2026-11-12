# Gerador de Postagens — @mpjnutri

Aplicação web estática para criar e exportar peças para redes sociais.

## Acesso

Depois que o GitHub Pages concluir a publicação:
https://mpjbiologo.github.io/gerador-postagens-mpjnutri/

## Publicação

O site é publicado automaticamente pelo GitHub Actions sempre que houver alterações na branch `main`.

## Dados e privacidade

O aplicativo utiliza armazenamento local do navegador (`localStorage`) para preferências, histórico e conteúdo salvo. Esses dados permanecem no navegador/dispositivo em que foram criados; não há sincronização em nuvem entre dispositivos nesta versão.

## Integração em nuvem (em implantação)

A base de conexão e autenticação Supabase está disponível em **Configurações → Nuvem**. A configuração exige um projeto Supabase próprio. O passo a passo está em [SUPABASE_SETUP.md](SUPABASE_SETUP.md), e o SQL inicial com tabelas, RLS e bucket privado está em [supabase/schema.sql](supabase/schema.sql).

A autenticação e a sincronização bidirecional de projetos e calendário estão implementadas, incluindo propagação de exclusões. A mídia de vídeo do IndexedDB e o upload/recuperação de arquivos no Storage ainda serão integrados. Consulte `SUPABASE_SETUP.md` e execute o SQL atualizado antes de usar a sincronização.

## Desenvolvimento

Abra `index.html` em um navegador ou sirva a pasta com qualquer servidor HTTP estático.
