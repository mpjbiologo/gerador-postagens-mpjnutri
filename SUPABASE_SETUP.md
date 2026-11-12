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
4. O script cria as tabelas de projetos, calendário e marcadores de exclusão, ativa Row Level Security (RLS) e cria o bucket privado de imagens e vídeos.
5. Confira em **Table Editor** se existem `mpjnutri_projects` e `mpjnutri_editorial_plan`, e `mpjnutri_sync_tombstones`, e em **Storage** se existe `mpjnutri-assets` como bucket privado.

As políticas limitam leitura e gravação ao usuário autenticado dono dos registros e arquivos. Não desative RLS.

## 3. Copiar as credenciais públicas

1. Abra **Project Settings → API** (ou a seção **Connect** / **API Keys**, conforme a interface).
2. Copie a **Project URL**.
3. Copie a chave pública **publishable** (prefixo `sb_publishable_`) ou a chave pública legada **anon**.
4. Não copie nem compartilhe a chave `service_role`, `secret` ou senha do banco.

A URL e a chave pública são usadas no navegador. A segurança depende das políticas RLS do banco e do Storage.

## 4. Habilitar o login com GitHub

O login no painel do Supabase pela sua conta GitHub não habilita automaticamente o GitHub como provedor de autenticação dos usuários do gerador. É uma configuração separada, feita uma única vez no projeto.

1. No painel do Supabase, abra **Authentication → Sign In / Providers** (ou **Providers**) e expanda **GitHub**.
2. Copie a **Callback URL** exibida pelo Supabase. Ela terá este formato: `https://<project-ref>.supabase.co/auth/v1/callback`.
3. Abra https://github.com/settings/developers e entre em **OAuth Apps**. Clique em **New OAuth App**.
4. Preencha:
   - **Application name:** Gerador de Postagens MPJ Nutri
   - **Homepage URL:** `https://mpjbiologo.github.io/gerador-postagens-mpjnutri/gerador.html`
   - **Authorization callback URL:** cole exatamente a Callback URL copiada do Supabase.
5. Registre o aplicativo no GitHub. Copie o **Client ID** e gere um **Client secret**.
6. Volte ao Supabase, ative **GitHub Enabled**, cole o Client ID e o Client secret e clique em **Save**.
7. No Supabase, abra **Authentication → URL Configuration**. Em **Redirect URLs**, adicione exatamente:
   `https://mpjbiologo.github.io/gerador-postagens-mpjnutri/gerador.html`
   Salve as alterações. Se necessário, configure também essa URL como **Site URL**.
8. Volte ao gerador e use **Configurações → Nuvem → Salvar e conectar** para conectar a URL e a chave pública do projeto. Depois clique em **Entrar com GitHub** e autorize o acesso.

**Importante:** o Client secret do GitHub deve ficar somente no painel do Supabase. Nunca o coloque no gerador, no repositório ou em arquivos públicos. O gerador usa apenas a URL e a chave pública do Supabase. O fluxo de login redireciona ao GitHub e retorna ao endereço do gerador.

## 5. Conectar no gerador

1. Abra https://mpjbiologo.github.io/gerador-postagens-mpjnutri/gerador.html
2. Clique em **Configurações → Nuvem**.
3. Cole a Project URL e a chave pública e clique em **Salvar e conectar**.
4. Clique em **Entrar com GitHub** e autorize o aplicativo.
5. A sessão do Supabase Auth será criada e a sincronização de projetos e calendário poderá começar.

O acesso por e-mail e senha continua disponível como alternativa, dentro de **Outras formas de acesso**.

A configuração pública fica salva apenas neste navegador. A senha não é armazenada pelo gerador; o Supabase Auth mantém a sessão. Para evitar misturar dados de contas diferentes, o perfil do navegador fica vinculado ao primeiro usuário autenticado. Para usar outra conta, utilize outro perfil de navegador ou faça backup e limpe os dados locais antes de trocar.

## Estado da integração

A integração já permite autenticação e sincronização bidirecional de projetos e calendário. A sincronização mescla os registros por identificador e data de atualização, sem apagar registros por conflito. Exclusões feitas depois de vincular a conta são propagadas por marcadores próprios, protegidos por RLS. A sincronização automática ocorre após alterações locais quando há sessão e conexão; também existe o botão **Sincronizar agora**.

A mídia de vídeo armazenada no IndexedDB ainda não é enviada ao Storage. Imagens incorporadas aos dados do projeto podem aumentar bastante o tamanho dos registros; o envio de arquivos para o bucket privado será concluído em etapa própria. A sincronização requer que o SQL atualizado deste repositório seja executado no projeto Supabase. Os dados locais continuam sendo preservados.

## Segurança e recuperação

- Nunca use uma chave `service_role` no navegador, no GitHub Pages ou neste repositório.
- Mantenha RLS ativado nas tabelas e políticas do Storage.
- Use senha forte e confirmação de e-mail.
- Faça backup local dos projetos antes da próxima etapa de sincronização.


## Referências oficiais

- [Supabase: Sign in with GitHub](https://supabase.com/docs/guides/auth/social-sign-in/auth-github)
- [GitHub: Creating an OAuth app](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/creating-an-oauth-app)
