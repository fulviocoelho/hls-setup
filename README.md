# 🏠 Homelab Container Server para Rede LAN

Este repositório contém scripts e configurações para montar um **homelab** que disponibiliza serviços baseados em containers para sua rede local (**LAN**), de forma prática e escalável.

## 📋 Pré-requisitos

Antes de começar, é **fortemente recomendado** instalar o **Ubuntu Server** na máquina que será o servidor.  
Baixe a ISO mais recente em: [https://ubuntu.com/download/server](https://ubuntu.com/download/server)

> É recomendável utilizar uma máquina dedicada ou um mini-PC/servidor para maior estabilidade.

## 🌐 Configurando a Rede do Servidor

Após a instalação do Ubuntu Server, configure a rede seguindo os passos abaixo:

1. Listar arquivos de configuração do Netplan:
```bash
ls /etc/netplan/
```

2. Editar o arquivo de configuração (substitua pelo nome listado no comando anterior):

```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

3. Ajustar o conteúdo conforme necessário (substitua `ens33` pelo nome real da sua interface):

```yaml
network:
  version: 2
  ethernets:
    ens33: # Nome da sua interface
      dhcp4: true
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4] # DNS desejado
```

4. Aplicar as configurações:

```bash
sudo netplan apply
```

5. Verificar o status da resolução de nomes:

```bash
resolvectl status
```

6. Testar o Docker (confira se está instalado corretamente):

```bash
docker pull hello-world
```

## ⚙️ Preparando a Interface LAN do Docker

Para criar a interface de rede LAN para os containers, rode:

```bash
./create-lan-net-interface.sh
```

> Este script utiliza as variáveis definidas no arquivo `.env`.
> Certifique-se de configurar corretamente os dados nesse arquivo antes de executar.

## 🛠 Configurando o Portainer como Serviço

O Portainer permite gerenciar containers via interface web.
Para criar o serviço no **systemd**, execute:

```bash
sudo ./create-portainer-service.sh
```

Após iniciado, o Portainer estará disponível na **porta 80** do IP do servidor.

## 👤 Permitir que Usuário Não-Root Use o Docker

Para configurar o Docker e permitir que o seu usuário execute comandos sem `sudo`:

```bash
./setup-docker-for-me.sh
```

Após isso, **reinicie a sessão** para aplicar as permissões.

## 📦 Stacks e Configurações Recomendadas

As **stacks recomendadas** para este homelab estão disponíveis na pasta:

```
Stacks/
```

Você pode importá-las diretamente no Portainer para iniciar rapidamente os serviços.

## 📡 Acesso ao Portainer

Após concluir a configuração, acesse:

```
http://<IP_DO_SERVIDOR>:80
```