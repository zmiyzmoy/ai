#!/bin/bash

# Создание директорий и файлов
mkdir -p ai-agent-platform/{configs,core,dev_gui,i18n,tests,ui/telegram_bot,ui/whatsapp_evolution,ui/instagram,ui/tiktok} && \
touch ai-agent-platform/{configs/tourism.yaml,configs/beauty_salon.yaml,configs/green_travel.yaml,core/__init__.py,core/actions.py,core/flows_loader.py,core/router.py,core/triggers.py,dev_gui/__init__.py,dev_gui/editor.py,i18n/{az.json,en.json},tests/__init__.py,tests/test_router.py,ui/__init__.py,ui/telegram_bot/{__init__.py,main.py},ui/whatsapp_evolution/{__init__.py,main.py},ui/instagram/{__init__.py,main.py},ui/tiktok/{__init__.py,main.py},Dockerfile.fundament,docker-compose.yml,init_mongo.py,main.py,manage_clients.py,requirements.txt,tours.csv}

# Добавление кода в файлы
# configs/tourism.yaml
cat << 'EOF' > ai-agent-platform/configs/tourism.yaml
default_response:
  az: "Salam! Tur seçmək üçün 'Tur seç' yazın."
  en: "Hello! To choose a tour, type 'Choose tour'."
flows:
  choose_tour:
    az: "Tur seçmək üçün adınızı, telefon nömrənizi və destinansiyan qeyd edin."
    en: "To choose a tour, provide your name, phone number, and destination."
steps:
  - fields:
      - name: "Ad"
        validation: ""
      - name: "Telefon"
        validation: "phone"
      - name: "Destinasiya"
        validation: ""
submit_to: "http://n8n:5678/webhook"
submit_to_email: "http://n8n:5678/form-email"
thanks:
  az: "Tur üçün təşəkkür edirik! Tezliklə sizinlə əlaqə saxlayacağıq."
  en: "Thank you for choosing a tour! We will contact you soon."
EOF

# configs/beauty_salon.yaml
cat << 'EOF' > ai-agent-platform/configs/beauty_salon.yaml
default_response:
  az: "Xoş gəlmisiniz! Xidmət seçmək üçün 'Xidmət seç' yazın."
  en: "Welcome! To choose a service, please type 'Choose service'."
flows:
  choose_service:
    az: "Xidmət seçmək üçün zəhmət olmasa adınızı, telefon nömrənizi və istədiyiniz xidməti qeyd edin."
    en: "To choose a service, please provide your name, phone number, and desired service."
steps:
  - fields:
      - name: "Имя"
        validation: ""
      - name: "Телефон"
        validation: "phone"
      - name: "Xidmət"
        validation: ""
submit_to: "http://n8n:5678/webhook"
submit_to_email: "http://n8n:5678/form-email"
thanks:
  az: "Sizin üçün randevu təşkil edirik. Tezliklə sizinlə əlaqə saxlayacağıq!"
  en: "We are scheduling your appointment. We will contact you soon!"
EOF

# configs/green_travel.yaml
cat << 'EOF' > ai-agent-platform/configs/green_travel.yaml
default_response:
  az: "Salam! Ekotur üçün müraciət etmək üçün 'Tur seç' yazın."
  en: "Hello! To book an eco-tour, type 'Choose tour'."
flows:
  choose_tour:
    az: "Ekotur seçmək üçün adınızı, telefon nömrənizi və istədiyiniz destinansiyan qeyd edin."
    en: "To choose an eco-tour, provide your name, phone number, and desired destination."
steps:
  - fields:
      - name: "Ad"
        validation: ""
      - name: "Telefon"
        validation: "phone"
      - name: "Destinasiya"
        validation: ""
submit_to: "http://n8n:5678/webhook"
submit_to_email: "http://n8n:5678/form-email"
thanks:
  az: "Ekotur üçün təşəkkür edirik! Tezliklə sizinlə əlaqə saxlayacağıq."
  en: "Thank you for choosing an eco-tour! We will contact you soon."
EOF

# core/__init__.py
cat << 'EOF' > ai-agent-platform/core/__init__.py
# Package initialization
EOF

# core/actions.py
cat << 'EOF' > ai-agent-platform/core/actions.py
import logging
from aiogram.fsm.context import FSMContext

logger = logging.getLogger(__name__)

async def execute_action(client_id: str, user_id: str, intent: str, flow: dict, state: FSMContext, lang: str):
    return flow.get(lang, "Action not implemented yet.")
EOF

# core/flows_loader.py
cat << 'EOF' > ai-agent-platform/core/flows_loader.py
import yaml
import logging

logger = logging.getLogger(__name__)

def load_flows(config_file: str) -> dict:
    try:
        with open(config_file, "r", encoding="utf-8") as file:
            flows = yaml.safe_load(file)
        return flows
    except Exception as e:
        logger.error(f"Failed to load flows from {config_file}: {e}")
        return {}
EOF

# core/router.py
cat << 'EOF' > ai-agent-platform/core/router.py
import logging
import httpx
import re
from motor.motor_asyncio import AsyncIOMotorClient
from core.flows_loader import load_flows
from core.triggers import match_intent
from core.actions import execute_action
from cachetools import TTLCache
from aiogram.fsm.context import FSMContext
from datetime import datetime

logger = logging.getLogger(__name__)
flows_cache = TTLCache(maxsize=10, ttl=300)  # Cache для нескольких клиентов

# MongoDB
client = AsyncIOMotorClient("mongodb://mongodb:27017")
db = client["ai_agent"]

async def get_client(client_id: str):
    return await db.clients.find_one({"client_id": client_id})

async def get_flows(client_id: str):
    client = await get_client(client_id)
    config_file = client.get("config_file", f"configs/{client_id}.yaml")
    if config_file not in flows_cache:
        flows_cache[config_file] = load_flows(config_file)
    return flows_cache[config_file]

async def get_weather(city="Baku"):
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post("http://n8n:5678/weather-webhook", json={"city": city})
            response.raise_for_status()
            data = response.json()
            return f"В {city} сейчас {data['weather'][0]['description']}, температура {data['main']['temp']}°C."
    except httpx.HTTPError as e:
        logger.error(f"Weather API error: {e}")
        return "Не удалось получить данные о погоде."

async def get_dialog_history(user_id: str, client_id: str, limit=5):
    history = await db.dialogs.find(
        {"user_id": user_id, "client_id": client_id},
        sort=[("timestamp", -1)],
        limit=limit
    ).to_list(None)
    return history[::-1]  # Возвращаем в хронологическом порядке

async def call_openrouter(client_id: str, user_id: str, text: str, lang="az", weather_info="", tone="дружелюбный"):
    client = await get_client(client_id)
    persona = client.get("persona", "дружелюбный помощник")
    tone_prompt = f"Use a {tone} tone" if tone else ""
    history = await get_dialog_history(user_id, client_id)
    
    api_key = "your-openrouter-api-key"  # Замените на ваш ключ с OpenRouter
    url = "https://openrouter.ai/api/v1/chat/completions"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    
    # Формируем историю диалога для контекста
    messages = [
        {"role": "system", "content": f"You are a {persona} for a {client['name']}. {tone_prompt}. Provide human-like responses and redirect users to relevant services or products."}
    ]
    for entry in history:
        messages.append({"role": "user", "content": entry["input"]})
        messages.append({"role": "assistant", "content": entry["response"]})
    messages.append({"role": "user", "content": f"{text}\nWeather info: {weather_info}")
    
    data = {
        "model": "deepseek/deepseek-chat",
        "messages": messages,
        "max_tokens": 150
    }
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(url, json=data, headers=headers)
            response.raise_for_status()
            return response.json()["choices"][0]["message"]["content"]
    except httpx.HTTPError as e:
        logger.error(f"OpenRouter API error: {e}")
        return "Извините, произошла ошибка при обработке вашего запроса."

async def get_popular_item(client_id: str):
    if client_id == "tourism":
        item = await db.destinations.find_one({"client_id": client_id}, sort=[("popularity", -1)])
        if not item:
            return {"name": "Дубай", "description": "солнечно и тепло круглый год"}
        return item
    elif client_id == "beauty_salon":
        item = await db.services.find_one({"client_id": client_id}, sort=[("price", -1)])
        if not item:
            return {"name": "Макияж", "description": "вечерний макияж для особых случаев", "price": 70}
        return item
    elif client_id == "green_travel":
        item = await db.destinations.find_one({"client_id": client_id}, sort=[("popularity", -1)])
        if not item:
            return {"name": "Дубай", "description": "солнечно и тепло круглый год", "price": 500}
        return item
    return {"name": "услугу", "description": "подходящую для вас"}

async def process_message(client_id: str, user_id: str, text: str, state: FSMContext, lang: str = "az"):
    client = await get_client(client_id)
    tone = client.get("tone", "дружелюбный")
    flows = await get_flows(client_id)
    intent = match_intent(text, flows)
    response = flows.get("default_response", {}).get(lang, "Извините, я не понял ваш запрос.")

    # Log dialog to MongoDB with current timestamp
    await db.dialogs.insert_one({
        "client_id": client_id,
        "user_id": user_id,
        "input": text,
        "intent": intent,
        "response": response,
        "lang": lang,
        "timestamp": datetime.utcnow().isoformat() + "+00:00"
    })

    if intent:
        logger.debug(f"Matched intent: {intent}")
        await db.stats.insert_one({"client_id": client_id, "user_id": user_id, "intent": intent, "text": text})
        return await execute_action(client_id, user_id, intent, flows[intent], state, lang)
    else:
        # Проверяем, есть ли запрос о погоде
        weather_keywords = ["погода", "weather", "какая сегодня погода"]
        weather_info = ""
        if any(keyword in text.lower() for keyword in weather_keywords):
            city = "Baku"
            for word in text.split():
                if word in ["Баку", "Дубай", "Турция", "Мальдивы"]:
                    city = word
            weather_info = await get_weather(city)

        # Используем ИИ для ответа
        ai_response = await call_openrouter(client_id, user_id, text, lang, weather_info, tone)
        # Извлекаем популярный элемент
        item = await get_popular_item(client_id)
        redirect_message = f"{ai_response} А у нас есть {item['name']} — {item['description']}. Хотите узнать больше? Напишите 'Tur seç' или 'Choose service'."
        return redirect_message

async def process_fsm_input(client_id: str, user_id: str, text: str, state: FSMContext, lang: str):
    data = await state.get_data()
    step = data.get("step", 0)
    config = data.get("config")
    steps = config["steps"][0]["fields"]

    field = steps[step]
    if "validation" in field:
        if not validate_input(text, field["validation"]):
            return f"Неверный формат для {field['name']}. Попробуйте снова:", False

    answers = data.get("answers", [])
    answers.append(text)
    step += 1

    if step < len(steps):
        await state.update_data(step=step, answers=answers)
        return f"{steps[step]['name']}:", False
    else:
        payload = dict(zip([f["name"] for f in steps], answers))
        if "submit_to" in config:
            if not config["submit_to"].startswith("https://"):
                logger.error("Webhook must use HTTPS")
                return "Ошибка: Webhook должен использовать HTTPS", True
            async with httpx.AsyncClient(timeout=10.0) as client:
                try:
                    response = await client.post(config["submit_to"], json=payload)
                    response.raise_for_status()
                    logger.info(f"Webhook sent: {payload}")
                    if "submit_to_email" in config:
                        response = await client.post(config["submit_to_email"], json=payload)
                        response.raise_for_status()
                        logger.info(f"Email webhook sent: {payload}")
                except httpx.HTTPError as e:
                    logger.error(f"Webhook HTTP error: {e}")
                    return f"Ошибка при отправке заявки: {e}", True
                except httpx.RequestError as e:
                    logger.error(f"Webhook network error: {e}")
                    return f"Ошибка сети: {e}", True

        await db.forms.insert_one({"client_id": client_id, "user_id": user_id, "form": payload})
        return config.get("thanks", {}).get(lang, "Ваша заявка отправлена. Спасибо!"), True

def validate_input(text: str, validation: str) -> bool:
    if validation == "phone":
        return bool(re.match(r"^\+?\d{10,15}$", text))
    if validation == "number":
        return text.isdigit()
    return True

async def execute_action(client_id: str, user_id: str, intent: str, flow: dict, state: FSMContext, lang: str):
    return flow.get(lang, "Action not implemented yet.")
EOF

# core/triggers.py
cat << 'EOF' > ai-agent-platform/core/triggers.py
import logging

logger = logging.getLogger(__name__)

def match_intent(text: str, flows: dict) -> str:
    for intent, flow in flows.items():
        if intent == "default_response":
            continue
        for lang, trigger in flow.items():
            if text.lower() in trigger.lower():
                return intent
    return None
EOF

# dev_gui/__init__.py
cat << 'EOF' > ai-agent-platform/dev_gui/__init__.py
# Package initialization
EOF

# dev_gui/editor.py
cat << 'EOF' > ai-agent-platform/dev_gui/editor.py
from flask import Flask, request, render_template_string
import yaml
import os

app = Flask(__name__)

@app.route("/editor", methods=["GET", "POST"])
def editor():
    config_path = os.getenv("CONFIG_PATH", "configs/default.yaml")
    if request.method == "POST":
        data = request.form.get("config")
        with open(config_path, "w", encoding="utf-8") as f:
            f.write(data)
        return "Config updated!"
    with open(config_path, "r", encoding="utf-8") as f:
        config_content = f.read()
    return render_template_string("""
        <form method="post">
            <textarea name="config" rows="20" cols=80">{{ config_content }}</textarea><br>
            <button type="submit">Save</button>
        </form>
    """, config_content=config_content)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

# i18n/az.json
cat << 'EOF' > ai-agent-platform/i18n/az.json
{
  "welcome": "Xoş gəlmisiniz!",
  "error": "Xəta baş verdi."
}
EOF

# i18n/en.json
cat << 'EOF' > ai-agent-platform/i18n/en.json
{
  "welcome": "Welcome!",
  "error": "An error occurred."
}
EOF

# tests/__init__.py
cat << 'EOF' > ai-agent-platform/tests/__init__.py
# Package initialization
EOF

# tests/test_router.py
cat << 'EOF' > ai-agent-platform/tests/test_router.py
import pytest
from core.router import process_message

@pytest.mark.asyncio
async def test_router():
    # Тестовая реализация
    assert True
EOF

# ui/__init__.py
cat << 'EOF' > ai-agent-platform/ui/__init__.py
# Package initialization
EOF

# ui/telegram_bot/__init__.py
cat << 'EOF' > ai-agent-platform/ui/telegram_bot/__init__.py
# Package initialization
EOF

# ui/telegram_bot/main.py
cat << 'EOF' > ai-agent-platform/ui/telegram_bot/main.py
import logging
from aiogram import Bot, Dispatcher, types
from aiogram.fsm.storage.memory import MemoryStorage
from aiogram.fsm.context import FSMContext
from aiogram.fsm.state import State, StatesGroup
from aiogram.types import Message
import asyncio
from core.router import process_message, process_fsm_input

logger = logging.getLogger(__name__)

class FormState(StatesGroup):
    waiting_for_field = State()

async def start_telegram(client_id: str, telegram_token: str):
    if not telegram_token:
        logger.error("TELEGRAM_TOKEN not set")
        raise ValueError("TELEGRAM_TOKEN is missing")

    bot = Bot(token=telegram_token)
    dp = Dispatcher(storage=MemoryStorage())

    @dp.message()
    async def on_message(message: Message, state: FSMContext):
        user_id = str(message.from_user.id)
        lang = message.from_user.language_code or "az"
        logger.info(f"User {user_id} sent: {message.text}")

        current_state = await state.get_state()
        if current_state == FormState.waiting_for_field.state:
            response, done = await process_fsm_input(client_id, user_id, message.text, state, lang)
            await message.answer(response)
            if done:
                await state.clear()
        else:
            response = await process_message(client_id, user_id, message.text, state, lang)
            await message.answer(response)

    try:
        logger.info(f"Starting Telegram bot for client {client_id}")
        await dp.start_polling(bot)
    except Exception as e:
        logger.error(f"Telegram bot error: {e}")
        raise

if __name__ == "__main__":
    asyncio.run(start_telegram("${CLIENT_ID}", "${TELEGRAM_TOKEN}"))
EOF

# ui/whatsapp_evolution/__init__.py
cat << 'EOF' > ai-agent-platform/ui/whatsapp_evolution/__init__.py
# Package initialization
EOF

# ui/whatsapp_evolution/main.py
cat << 'EOF' > ai-agent-platform/ui/whatsapp_evolution/main.py
import asyncio
import logging
import httpx
from aiohttp import web
from core.router import process_message
from aiogram.fsm.storage.memory import MemoryStorage
from aiogram.fsm.context import FSMContext

logger = logging.getLogger(__name__)

async def send_message(phone: str, message: str, api_url: str, api_key: str):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(
                f"{api_url}/message/sendText/default",
                json={"number": phone, "text": message},
                headers={"apikey": api_key}
            )
            response.raise_for_status()
            logger.info(f"Sent message to {phone}: {message}")
        except httpx.HTTPError as e:
            logger.error(f"Failed to send message to {phone}: {e}")

async def webhook_handler(request):
    client_id = request.app["client_id"]
    storage = MemoryStorage()
    state = FSMContext(storage=storage, key=("whatsapp", request.remote))
    data = await request.json()
    logger.debug(f"Received webhook for {client_id}: {data}")

    if "message" in data and "text" in data["message"]:
        user_id = data["message"]["from"]
        text = data["message"]["text"]["body"]
        lang = "az"  # Default language
        response = await process_message(client_id, user_id, text, state, lang)
        await send_message(user_id, response, request.app["api_url"], request.app["api_key"])
    return web.Response(text="OK")

async def start_whatsapp(client_id: str, api_url: str, api_key: str, webhook_url: str, port=8080):
    app = web.Application()
    app["client_id"] = client_id
    app["api_url"] = api_url
    app["api_key"] = api_key
    app.add_routes([web.post("/webhook", webhook_handler)])

    # Register webhook with Evolution API
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(
                f"{api_url}/webhook",
                json={"url": webhook_url},
                headers={"apikey": api_key}
            )
            response.raise_for_status()
            logger.info(f"Webhook registered at {webhook_url} for {client_id}")
        except httpx.HTTPError as e:
            logger.error(f"Failed to register webhook: {e}")

    runner = web.AppRunner(app)
    await runner.setup()
    site = web.TCPSite(runner, "0.0.0.0", port)
    logger.info(f"Starting WhatsApp webhook server on port {port} for {client_id}")
    await site.start()
    await asyncio.Event().wait()  # Keep running

if __name__ == "__main__":
    asyncio.run(start_whatsapp("${CLIENT_ID}", "http://evolution-api:8080", "${WHATSAPP_API_KEY}", "http://localhost:8080/webhook", 8080))
EOF

# ui/instagram/__init__.py
cat << 'EOF' > ai-agent-platform/ui/instagram/__init__.py
# Package initialization
EOF

# ui/instagram/main.py
cat << 'EOF' > ai-agent-platform/ui/instagram/main.py
import asyncio
import logging
from instagrapi import Client
from core.router import process_message
from aiogram.fsm.storage.memory import MemoryStorage
from aiogram.fsm.context import FSMContext

logger = logging.getLogger(__name__)

async def start_instagram(client_id: str, username: str, password: str, verification_code=None):
    storage = MemoryStorage()
    cl = Client()
    try:
        # Попытка входа
        if verification_code:
            cl.set_two_factor(verification_code)
        cl.login(username, password)
        logger.info(f"Instagram logged in for {username}")
    except Exception as e:
        logger.error(f"Instagram login failed: {e}")
        if "two_factor_required" in str(e):
            # Запрос кода 2FA (можно вручную ввести или взять из резервного кода)
            code = input("Enter 2FA code: ")
            await start_instagram(client_id, username, password, code)
        return

    while True:
        try:
            threads = cl.direct_threads(amount=10)
            for thread in threads:
                user_id = thread.id
                state = FSMContext(storage=storage, key=("instagram", user_id))
                messages = thread.messages
                if messages:
                    last_message = messages[0]
                    if last_message.user_id != cl.user_id:  # Не обрабатываем свои сообщения
                        text = last_message.text
                        logger.info(f"Instagram message from {user_id}: {text}")
                        response = await process_message(client_id, user_id, text, state, "az")
                        cl.direct_send(response, [user_id])
                        logger.info(f"Sent response to {user_id}: {response}")
            await asyncio.sleep(10)  # Проверяем каждые 10 секунд
        except Exception as e:
            logger.error(f"Instagram error: {e}")
            await asyncio.sleep(60)

if __name__ == "__main__":
    asyncio.run(start_instagram("${CLIENT_ID}", "${INSTAGRAM_USERNAME}", "${INSTAGRAM_PASSWORD}"))
EOF

# ui/tiktok/__init__.py
cat << 'EOF' > ai-agent-platform/ui/tiktok/__init__.py
# Package initialization
EOF

# ui/tiktok/main.py
cat << 'EOF' > ai-agent-platform/ui/tiktok/main.py
import asyncio
import logging
import httpx
from core.router import process_message
from aiogram.fsm.storage.memory import MemoryStorage
from aiogram.fsm.context import FSMContext

logger = logging.getLogger(__name__)

async def send_message_to_manychat(user_id: str, message: str, manychat_api_token: str):
    url = "https://api.manychat.com/fb/sending/sendContent"
    headers = {"Authorization": f"Bearer {manychat_api_token}"}
    data = {
        "subscriber_id": user_id,
        "message": message
    }
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(url, json=data, headers=headers)
            response.raise_for_status()
            logger.info(f"Sent message to {user_id} via ManyChat: {message}")
        except httpx.HTTPError as e:
            logger.error(f"ManyChat error: {e}")

async def start_tiktok(client_id: str, manychat_api_token: str):
    storage = MemoryStorage()
    
    # Подключение к TikTok через ManyChat Webhook
    async with httpx.AsyncClient() as client:
        while True:
            try:
                # Получение новых взаимодействий через ManyChat
                # Это пример, настройте Webhook в ManyChat для получения комментариев
                response = await client.get(f"https://api.manychat.com/tiktok/interactions?client_id={client_id}")
                interactions = response.json().get("interactions", [])
                
                for interaction in interactions:
                    user_id = interaction["user_id"]
                    text = interaction.get("text", "")
                    if text:
                        state = FSMContext(storage=storage, key=("tiktok", user_id))
                        response = await process_message(client_id, user_id, text, state, "az")
                        await send_message_to_manychat(user_id, response, manychat_api_token)
            except Exception as e:
                logger.error(f"TikTok/ManyChat error: {e}")
            await asyncio.sleep(60)  # Проверяем каждую минуту

if __name__ == "__main__":
    asyncio.run(start_tiktok("${CLIENT_ID}", "${MANYCHAT_API_TOKEN}"))
EOF

# Dockerfile.fundament
cat << 'EOF' > ai-agent-platform/Dockerfile.fundament
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "main.py"]
EOF

# docker-compose.yml
cat << 'EOF' > ai-agent-platform/docker-compose.yml
version: '3.8'

services:
  ai_agent:
    build:
      context: .
      dockerfile: Dockerfile.fundament
    ports:
      - "8000:8000"
    environment:
      - CLIENT_ID=${CLIENT_ID}
    depends_on:
      - mongodb
    restart: unless-stopped
    networks:
      app-network:
        aliases:
          - ai_agent

  mongodb:
    image: mongo:6
    container_name: mongodb
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db
    restart: unless-stopped
    networks:
      app-network:
        aliases:
          - mongodb

  n8n:
    image: n8nio/n8n
    ports:
      - "5678:5678"
    environment:
      - DB_TYPE=sqlite
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=secure-n8n-password
    volumes:
      - n8n_data:/home/node/.n8n
    restart: unless-stopped
    networks:
      app-network:
        aliases:
          - n8n

  evolution_api:
    image: atendai/evolution-api:latest
    ports:
      - "8080:8080"
    environment:
      - API_KEY=${WHATSAPP_API_KEY}
      - WEBHOOK_URL=http://ai_agent:8000/webhook
      - DB_TYPE=mongodb
      - DB_HOST=mongodb
      - DB_PORT=27017
      - DB_NAME=ai_agent
    depends_on:
      - mongodb
    restart: unless-stopped
    networks:
      app-network:
        aliases:
          - evolution-api

  init_mongo:
    build:
      context: .
      dockerfile: Dockerfile.init_mongo
    depends_on:
      - mongodb
    networks:
      app-network:
        aliases:
          - init_mongo

networks:
  app-network:
    driver: bridge

volumes:
  mongo_data:
  n8n_data:
EOF

# Dockerfile.init_mongo
cat << 'EOF' > ai-agent-platform/Dockerfile.init_mongo
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt init_mongo.py ./
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "init_mongo.py"]
EOF

# init_mongo.py
cat << 'EOF' > ai-agent-platform/init_mongo.py
import asyncio
import csv
from motor.motor_asyncio import AsyncIOMotorClient

async def init_mongo():
    client = AsyncIOMotorClient("mongodb://mongodb:27017")
    db = client["ai_agent"]
    
    # Добавление клиентов
    clients = [
        {
            "client_id": "tourism",
            "name": "Tourism Agency",
            "config_file": "configs/tourism.yaml",
            "persona": "дружелюбный турагент",
            "tone": "дружелюбный",
            "messengers": {
                "telegram": {"token": "tourism-telegram-token"},
                "whatsapp": {"api_key": "tourism-whatsapp-key", "webhook_url": "http://ai_agent:8000/webhook"},
                "instagram": {"username": "tourism_inst", "password": "your-tourism-password"},
                "tiktok": {"manychat_api_token": "tourism-manychat-token"}
            }
        },
        {
            "client_id": "beauty_salon",
            "name": "Beauty Salon",
            "config_file": "configs/beauty_salon.yaml",
            "persona": "вежливый стилист",
            "tone": "формальный",
            "messengers": {
                "telegram": {"token": "beauty-telegram-token"},
                "whatsapp": {"api_key": "beauty-whatsapp-key", "webhook_url": "http://ai_agent:8000/webhook"},
                "instagram": {"username": "beauty_inst", "password": "your-beauty-password"},
                "tiktok": {"manychat_api_token": "beauty-manychat-token"}
            }
        },
        {
            "client_id": "green_travel",
            "name": "GreenTravel",
            "config_file": "configs/green_travel.yaml",
            "persona": "дружелюбный экологический гид",
            "tone": "дружелюбный",
            "messengers": {
                "telegram": {"token": "green-telegram-token"},
                "whatsapp": {"api_key": "green-whatsapp-key", "webhook_url": "http://ai_agent:8000/webhook"},
                "instagram": {"username": "green_travel_inst", "password": "your-green-password"},
                "tiktok": {"manychat_api_token": "green-manychat-token"}
            }
        }
    ]
    for client_data in clients:
        await db.clients.update_one({"client_id": client_data["client_id"]}, {"$set": client_data}, upsert=True)

    # Импорт туров из CSV
    with open("tours.csv", newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        destinations = []
        for row in reader:
            destinations.append({
                "client_id": "green_travel",
                "name": row["destination"],
                "description": row["description"],
                "popularity": int(row["popularity"]),
                "price": float(row["price"])
            })
        for dest in destinations:
            await db.destinations.update_one(
                {"client_id": dest["client_id"], "name": dest["name"]},
                {"$set": dest},
                upsert=True
            )

    # Общие настройки
    config = {
        "flask_secret_key": "super-secret-key",
        "editor_user": "admin",
        "editor_password": "admin123",
        "n8n_user": "admin",
        "n8n_password": "secure-n8n-password"
    }
    await db.config.update_one({"_id": "settings"}, {"$set": config}, upsert=True)
    
    print("MongoDB initialized with multiple clients and tours")

if __name__ == "__main__":
    asyncio.run(init_mongo())
EOF

# main.py
cat << 'EOF' > ai-agent-platform/main.py
import asyncio
import logging
import os
from motor.motor_asyncio import AsyncIOMotorClient
from ui.telegram_bot.main import start_telegram
from ui.whatsapp_evolution.main import start_whatsapp
from ui.instagram.main import start_instagram
from ui.tiktok.main import start_tiktok

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.FileHandler("ai_agent.log"), logging.StreamHandler()]
)
logger = logging.getLogger(__name__)

async def load_client():
    client_id = os.getenv("CLIENT_ID", "green_travel")  # По умолчанию green_travel
    if not client_id:
        logger.error("CLIENT_ID environment variable not set")
        raise ValueError("CLIENT_ID missing")
    
    client = AsyncIOMotorClient("mongodb://mongodb:27017")
    db = client["ai_agent"]
    client_data = await db.clients.find_one({"client_id": client_id})
    if not client_data:
        logger.error(f"Client {client_id} not found in MongoDB")
        raise ValueError(f"Client {client_id} missing")
    return client_data

async def main():
    print(f"Starting AI Agent for client {os.getenv('CLIENT_ID', 'green_travel')}...")
    client = await load_client()
    client_id = client["client_id"]
    messengers = client["messengers"]
    tasks = []
    whatsapp_ports = {"tourism": 8080, "beauty_salon": 8081, "green_travel": 8082}

    # Telegram
    if "telegram" in messengers:
        token = messengers["telegram"]["token"]
        tasks.append(start_telegram(client_id, token))
    
    # WhatsApp
    if "whatsapp" in messengers:
        api_key = messengers["whatsapp"]["api_key"]
        webhook_url = messengers["whatsapp"]["webhook_url"]
        port = whatsapp_ports.get(client_id, 8080)
        tasks.append(start_whatsapp(client_id, "http://evolution-api:8080", api_key, webhook_url, port))
    
    # Instagram
    if "instagram" in messengers:
        username = messengers["instagram"]["username"]
        password = messengers["instagram"]["password"]
        tasks.append(start_instagram(client_id, username, password))
    
    # TikTok
    if "tiktok" in messengers:
        manychat_api_token = messengers["tiktok"].get("manychat_api_token", "your-manychat-api-token")
        tasks.append(start_tiktok(client_id, manychat_api_token))

    try:
        await asyncio.gather(*tasks)
    except Exception as e:
        logger.error(f"Main loop error: {e}")
        print(f"Error: {e}")

if __name__ == "__main__":
    asyncio.run(main())
EOF

# manage_clients.py
cat << 'EOF' > ai-agent-platform/manage_clients.py
import asyncio
from motor.motor_asyncio import AsyncIOMotorClient

async def add_client(client_id, name, config_file, persona, tone, messengers):
    client = AsyncIOMotorClient("mongodb://mongodb:27017")
    db = client["ai_agent"]
    client_data = {
        "client_id": client_id,
        "name": name,
        "config_file": config_file,
        "persona": persona,
        "tone": tone,
        "messengers": messengers
    }
    await db.clients.update_one({"client_id": client_id}, {"$set": client_data}, upsert=True)
    print(f"Client {client_id} added/updated")

async def remove_client(client_id):
    client = AsyncIOMotorClient("mongodb://mongodb:27017")
    db = client["ai_agent"]
    await db.clients.delete_one({"client_id": client_id})
    await db.destinations.delete_many({"client_id": client_id})
    await db.services.delete_many({"client_id": client_id})
    print(f"Client {client_id} removed")

if __name__ == "__main__":
    # Пример добавления клиента
    asyncio.run(add_client(
        "new_client",
        "New Client",
        "configs/new_client.yaml",
        "дружелюбный помощник",
        "дружелюбный",
        {"telegram": {"token": "new-telegram-token"}, "whatsapp": {"api_key": "new-whatsapp-key", "webhook_url": "http://ai_agent:8000/webhook"}, "instagram": {"username": "new_inst", "password": "your-new-password"}, "tiktok": {"manychat_api_token": "new-manychat-token"}}
    ))
EOF

# requirements.txt
cat << 'EOF' > ai-agent-platform/requirements.txt
aiogram==3.8.0
httpx==0.27.0
pyyaml==6.0.1
motor==3.5.1
cachetools==5.5.0
flask==3.0.3
pytest==8.3.2
pytest-asyncio==0.23.8
aiohttp==3.9.5
pymongo==4.6.3
instagrapi==2.1.2
selenium==4.23.1
webdriver-manager==4.0.2
EOF

# tours.csv
cat << 'EOF' > ai-agent-platform/tours.csv
destination,description,popularity,price
Дубай,солнечно и тепло круглый год,100,500
Турция,приятный климат и пляжи,90,400
Мальдивы,идеально для отдыха на островах,80,800
EOF

echo "Project setup completed! Run 'docker-compose up -d' to start the project. To specify a client, use 'CLIENT_ID=<client_id> TELEGRAM_TOKEN=<token> WHATSAPP_API_KEY=<key> INSTAGRAM_USERNAME=<username> INSTAGRAM_PASSWORD=<password> MANYCHAT_API_TOKEN=<token> docker-compose up -d'."
