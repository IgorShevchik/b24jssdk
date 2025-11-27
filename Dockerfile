FROM node:22-bullseye-slim
LABEL maintainer="B24Sdk <github.com/bitrix24>"

RUN apt-get update && apt-get install -y \
    openssl \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

RUN corepack enable

# Копируем package.json и package-lock.json
COPY .npmrc .nuxtrc package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY docs/package.json ./docs/
COPY packages/jssdk/package.json ./packages/jssdk/
COPY packages/jssdk-nuxt/package.json ./packages/jssdk-nuxt/
COPY playgrounds/nuxt/package.json ./playgrounds/nuxt/
COPY docs/.output ./docs/.output/

# Устанавливаем зависимости для production
RUN pnpm install --prod --frozen-lockfile

RUN groupadd -r -g 1001 nodejs && useradd -r -u 1001 -g nodejs nuxtuser
RUN chown -R nuxtuser:nodejs /usr/src/app

USER nuxtuser

EXPOSE 80

CMD ["node", "/usr/src/app/docs/.output/server/index.mjs"]
