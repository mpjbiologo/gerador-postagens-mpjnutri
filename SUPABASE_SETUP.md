# Configuração da nuvem — Gerador MPJ Nutri

A integração usa Supabase para autenticação, banco de dados e armazenamento privado de arquivos. O gerador continua preservando os dados locais.

## 1. Criar seu projeto Supabase

1. Acesse https://supabase.com/dashboard e entre ou crie uma conta.
2. Clique em **New project**.
3. Escolha uma organização, nomeie o projeto (por exemplo, `mpjnutri-gerador`) e defina uma senha forte para o banco.
4. Escolha a região mais próxima disponível (preferencialmente São Paulo, se estiver disponível na sua conta).
5. Aguarde a criação do projeto.

Guarde a senha do banco em um gerenciador de senhas. Ela não é necessária no gerador.

## 2. Criar tabelas e armazenamento

1. Abra o projeto no Supabase.
2. Entre em **SQL Editor** e crie uma consulta.
3. Copie todo o conteúdo de `supabase/schema.sql` deste repositório, cole no editor e clique em **Run**.
4. O script cria as tabelas de projetos e calendário, ativa Row Level Security (RLS) e cria o bucket privado de imagens e vídeos.
5. Confira em **Table Editor** se existem `mpjnutri_projects` e `mpjnutri_editorial_plan`, e em **Storage** se existe `mpjnutri-assets` como bucket privado.

As políticas limitam leitura e gravação ao usuário autenticado dono dos registros e arquivos. Não desative RLS.

## 3. Copiar as credenciais públicas

1. Abra **Project Settings → API** (ou a seção **Connect** / **API Keys**, conforme a interface).
2. Copie a **Project URL**.
3. Copie a chave pública **publishable** (prefixo `sb_publishable_`) ou a chave pública legada **anon**.
4. Não copie nem compartilhe a chave `service_role`, `secret` ou senha do banco.

A URL e a chave pública são usadas no navegador. A segurança depende das políticas RLS do banco e do Storage.

## 4. Conectar no gerador

1. Abra https://mpjbiologo.github.io/gerador-postagens-mpjnutri/gerador.html
2. Clique em **Configurações → Nuvem**.
3. Cole a Project URL e a chave pública e clique em **Salvar e conectar**.
4. Informe seu e-mail e senha para criar a conta. Se a confirmação de e-mail estiver ativa, confirme o cadastro na mensagem recebida.
5. Depois, entre com suas credenciais.

A configuração pública fica salva apenas neste navegador. A senha não é armazenada pelo gerador; o Supabase Auth mantém a sessão.

## Estado desta entrega

Esta etapa entrega a base de conexão e autenticação. A sincronização dos projetos, calendário, rascunhos e upload/recuperação de mídia ainda não está ativada. Os dados locais não são apagados nem enviados automaticamente nesta etapa.

## Segurança e recuperação

- Nunca use uma chave `service_role` no navegador, no GitHub Pages ou neste repositório.
- Mantenha RLS ativado nas tabelas e políticas do Storage.
- Use senha forte e confirmação de e-mail.
- Faça backup local dos projetos antes da próxima etapa de sincronização.
