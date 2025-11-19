## Настрйока сервера

### Ставим докер

```bash
apt update && apt upgrade -y
apt install -y curl wget unzip htop
apt install -y htop
apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
apt update
apt install -y docker-ce docker-ce-cli containerd.io

docker --version
systemctl status docker

systemctl enable docker

docker run hello-world


systemctl restart docker
```

### Создание пользователя bitrix

```bash
adduser bitrix
usermod -aG sudo bitrix
usermod -aG docker bitrix


# Проверка прав sudo
su - bitrix
sudo whoami
exit

# Настройка sudo без пароля
visudo -f /etc/sudoers.d/bitrix

bitrix ALL=(ALL) NOPASSWD: ALL
```

### Отключение root-доступа по SSH:
```bash
sudo nano /etc/ssh/sshd_config

# Найдите строку и измените значение:
PermitRootLogin no

# Перезапустите SSH:
sudo systemctl restart ssh
```

### Установка make и базовых инструментов разработки
```bash
sudo apt update
sudo apt install -y make build-essential
sudo apt install -y gcc g++ libc6-dev autoconf automake pkg-config

make --version
gcc --version
which make
```

---

### Увеличить swap

> @todo Описать

## Сборка проекта на вашем компьютере

```bash
pnpm install
pnpm run dev:prepare
pnpm run docs:build
```

## Сборка Docker образа

Запусти Docker

```bash
# Соберите Docker образ
docker build -t b24js-app .
```

```bash
# Проверьте, что образ создан
docker images
```

## Тестирование контейнера локально

```bash
make prod-docs
```

## Сохранение образа в файл

```bash
# Сохраните образ в tar файл
docker save -o b24js-app.tar b24js-app
```

## Для переноса на сервер:

Скопируйте файлы на сервер (Можно использовать scp, rsync, или флешку):

- .env.prod
- docker-compose.prod.yml
- docker-compose.server.yml
- makefile
- b24js-app.tar

На сервере:

```bash
cd /home/bitrix/b24-js 

# Загрузите образ
docker load -i b24js-app.tar

# Проверьте, что образ загружен
docker images

# Запустите контейнер
make init-network
make init-nginxproxy
make prod-docs

make status
make ps

make down

df -h

htop

```


Открыть <https://b24js.bx-shef.by/b24jssdk/>
