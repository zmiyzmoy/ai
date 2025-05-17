Okay, I will combine the four bash script parts into a single, consolidated script. I'll ensure that common definitions (like variables and the `log` function) are included only once at the beginning, and the flow of operations from all parts is maintained. I've also corrected a minor typo (`esample` to `esac`) in one of the `log` function definitions that was present in your provided snippets.

Here is the combined bash script:

```bash
#!/bin/bash

# --- AI Agent Platform Merged MVP Setup Script ---
# This script creates the directory structure and necessary files for the project.
# It combines all parts into a single script for convenience.
# Copy and execute this script.

# --- Configuration ---
PROJECT_NAME="ai-agent-platform-merged"
PROJECT_DIR="./$PROJECT_NAME" # Default project directory

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для вывода сообщений
log() {
  local level=$1
  local message=$2
  local color=$NC
  
  case $level in
    "INFO") color=$BLUE ;;
    "SUCCESS") color=$GREEN ;;
    "WARNING") color=$YELLOW ;;
    "ERROR") color=$RED ;;
  esac
  
  echo -e "${color}[$level] $message${NC}"
}

log "INFO" "Запуск скрипта настройки AI Agent Platform (Merged MVP) - Часть 1: Создание структуры проекта и базовых файлов (Configs, i18n)..."

# --- Create Project Structure ---
log "INFO" "Создание структуры проекта в директории $PROJECT_DIR..."

# Используем && для остановки, если какая-то команда mkdir завершится с ошибкой
mkdir -p "$PROJECT_DIR" && \
mkdir -p "$PROJECT_DIR/configs" && \
mkdir -p "$PROJECT_DIR/core" && \
mkdir -p "$PROJECT_DIR/dev_gui" && \
mkdir -p "$PROJECT_DIR/i18n" && \
mkdir -p "$PROJECT_DIR/tests" && \
mkdir -p "$PROJECT_DIR/ui/telegram_bot" && \
mkdir -p "$PROJECT_DIR/ui/whatsapp_evolution" && \
mkdir -p "$PROJECT_DIR/ui/instagram" && \
mkdir -p "$PROJECT_DIR/ui/tiktok" && \
mkdir -p "$PROJECT_DIR/logs" # Добавлена для логов приложения

log "SUCCESS" "Структура директорий создана."

# --- Create Empty Files (Placeholder) ---
log "INFO" "Создание пустых файлов-заглушек..."

# Используем touch для создания всех файлов.
# Заменил core/init.py на core/__init__.py и т.д. для корректной структуры пакетов Python.
# Добавлены недостающие __init__.py
touch \
"$PROJECT_DIR/configs/tourism.yaml" \
"$PROJECT_DIR/configs/beauty_salon.yaml" \
"$PROJECT_DIR/configs/green_travel.yaml" \
"$PROJECT_DIR/core/__init__.py" \
"$PROJECT_DIR/core/config.py" \
"$PROJECT_DIR/core/database.py" \
"$PROJECT_DIR/core/processor.py" \
"$PROJECT_DIR/core/router.py" \
"$PROJECT_DIR/core/n8n_client.py" \
"$PROJECT_DIR/core/i18n.py" \
"$PROJECT_DIR/core/actions.py" \
"$PROJECT_DIR/core/triggers.py" \
"$PROJECT_DIR/dev_gui/__init__.py" \
"$PROJECT_DIR/dev_gui/editor.py" \
"$PROJECT_DIR/i18n/az.json" \
"$PROJECT_DIR/i18n/en.json" \
"$PROJECT_DIR/tests/__init__.py" \
"$PROJECT_DIR/tests/test_router.py" \
"$PROJECT_DIR/ui/__init__.py" \
"$PROJECT_DIR/ui/telegram_bot/__init__.py" \
"$PROJECT_DIR/ui/telegram_bot/main.py" \
"$PROJECT_DIR/ui/whatsapp_evolution/__init__.py" \
"$PROJECT_DIR/ui/whatsapp_evolution/main.py" \
"$PROJECT_DIR/ui/instagram/__init__.py" \
"$PROJECT_DIR/ui/instagram/main.py" \
"$PROJECT_DIR/ui/tiktok/__init__.py" \
"$PROJECT_DIR/ui/tiktok/main.py" \
"$PROJECT_DIR/Dockerfile.fundament" \
"$PROJECT_DIR/docker-compose.yml" \
"$PROJECT_DIR/Dockerfile.init_mongo" \
"$PROJECT_DIR/init_mongo.py" \
"$PROJECT_DIR/main.py" \
"$PROJECT_DIR/manage_clients.py" \
"$PROJECT_DIR/requirements.txt" \
"$PROJECT_DIR/tours.csv" \
"$PROJECT_DIR/.env.example" # Создаем файл-пример .env

log "SUCCESS" "Пустые файлы-заглушки созданы."

# --- Add Content to Files (Part 1) ---

log "INFO" "Наполнение файлов конфигурации (YAML)..."
# configs/tourism.yaml
cat << 'EOF' > "$PROJECT_DIR/configs/tourism.yaml"
# Конфигурация клиента "Туризм"
# Этот файл определяет потоки форм (FSM) и дефолтные ответы.
# Распознавание намерений теперь происходит через LLM.

# Дефолтный ответ, если LLM не смог сгенерировать или произошла ошибка обработки
# Ключ "default_response" зарезервирован.
default_response:
  az: "Salam! Necə kömək edə bilərəm?" # Пример дефолтного ответа на азербайджанском
  en: "Hello! How can I help you?" # Пример дефолтного ответа на английском

# Определение потоков форм (FSM)
# Ключ "flows" зарезервирован. Каждый ключ внутри "flows" - это имя формы,
# которое может быть использовано в действии "start_fsm" от LLM (например, {"type": "start_fsm", "form_name": "booking"}).
flows:
  # Пример формы для бронирования тура
  booking:
    # Текст, который будет показан при инициации этой формы (первый вопрос)
    # Роутер выберет нужный язык на основе LLM-определенного или дефолтного языка.
    az: "Tur üçün müraciət etmək üçün zəhmət olmasa adınızı, telefon nömrənizi və istədiyiniz destinasiyanı qeyd edin."
    en: "To book a tour, please provide your name, phone number, and desired destination."
    # TODO: Добавить другие языки, если нужны

    # Шаги формы - список полей, которые нужно собрать
    steps:
      - fields: # В MVP предполагаем один список полей в первом элементе списка steps
          - name: "Ad" # Название поля (используется в вопросе пользователю и как ключ в отправляемых данных)
            validation: "" # Тип валидации ("phone", "number", "" для без валидации)
            # TODO: Добавить локализованные названия полей
          - name: "Telefon"
            validation: "phone"
          - name: "Destinasiya"
            validation: ""

    # URL вебхука в n8n, куда будут отправлены данные формы после завершения
    # Должен быть доступен из контейнера ai_agent (http://n8n:5678 для обращения к сервису n8n)
    submit_to: "http://n8n:5678/webhook/tourism/booking"
    # Дополнительный вебхук, например, для отправки на email через n8n
    # submit_to_email: "http://n8n:5678/webhook/tourism/booking-email"

    # Сообщение, которое будет показано пользователю после успешного завершения формы
    thanks:
      az: "Tur üçün təşəkkür edirik! Tezliklə sizinlə əlaqə saxlayacağıq."
      en: "Thank you for booking a tour! We will contact you soon."
      # TODO: Добавить другие языки

  # TODO: Добавить другие потоки форм, если нужны (например, "callback_request", "ask_question_form" и т.д.)
  # example_form:
  #   en: "This is an example form. What is your favorite color?"
  #   steps:
  #     - fields:
  #         - name: "Color"
  #           validation: ""
  #   submit_to: "http://n8n:5678/webhook/example/form"
  #   thanks:
  #     en: "Thanks for your answer!"

EOF

# configs/beauty_salon.yaml
cat << 'EOF' > "$PROJECT_DIR/configs/beauty_salon.yaml"
# Конфигурация клиента "Салон Красоты"
# Этот файл определяет потоки форм (FSM) и дефолтные ответы.

default_response:
  az: "Xoş gəlmisiniz! Necə kömək edə bilərəm?"
  en: "Welcome! How can I help you?"

flows:
  # Пример формы для записи на услугу
  booking:
    az: "Xidmətə yazılmaq üçün zəhmət olmasa adınızı, telefon nömrənizi və istədiyiniz xidməti qeyd edin."
    en: "To book a service, please provide your name, phone number, and desired service."
    # TODO: Добавить другие языки

    steps:
      - fields:
          - name: "Имя" # TODO: Сделать названия полей локализуемыми через i18n
            validation: ""
          - name: "Telefon"
            validation: "phone"
          - name: "Xidmət"
            validation: ""

    submit_to: "http://n8n:5678/webhook/beauty_salon/booking"
    # submit_to_email: "http://n8n:5678/webhook/beauty_salon/booking-email"

    thanks:
      az: "Sizin üçün randevu təşkil edirik. Tezliklə sizinlə əlaqə saxlayacağıq!"
      en: "We are scheduling your appointment. We will contact you soon!"
      # TODO: Добавить другие языки

EOF

# configs/green_travel.yaml
cat << 'EOF' > "$PROJECT_DIR/configs/green_travel.yaml"
# Конфигурация клиента "Green Travel"
# Этот файл определяет потоки форм (FSM) и дефолтные ответы.

default_response:
  az: "Salam! Ekotur üçün müraciət etmək üçün necə kömək edə bilərəm?"
  en: "Hello! How can I help you book an eco-tour?"

flows:
  # Пример формы для бронирования экотура
  # Название формы "booking" совпадает с формой "tourism", это нормально,
  # если их функциональное назначение (бронирование) одинаково.
  # LLM должен использовать имя "booking" в действии start_fsm.
  booking:
    az: "Ekotur seçmək üçün adınızı, telefon nömrənizi və istədiyiniz destinasiyanı qeyd edin."
    en: "To choose an eco-tour, provide your name, phone number, and desired destination."
    # TODO: Добавить другие языки

    steps:
      - fields:
          - name: "Ad"
            validation: ""
          - name: "Telefon"
            validation: "phone"
          - name: "Destinasiya"
            validation: "" # Например, "Аляска", "Байкал", "Швейцария"

    submit_to: "http://n8n:5678/webhook/green_travel/booking"
    # submit_to_email: "http://n8n:5678/webhook/green_travel/booking-email"

    thanks:
      az: "Ekotur üçün təşəkkür edirik! Tezliklə sizinlə əlaqə saxlayacağıq."
      en: "Thank you for booking an eco-tour! We will contact you soon."
      # TODO: Добавить другие языки

EOF

log "SUCCESS" "YAML файлы конфигурации созданы/обновлены."


log "INFO" "Наполнение файлов локализации (i18n)..."
# i18n/az.json
cat << 'EOF' > "$PROJECT_DIR/i18n/az.json"
{
  "welcome": "Xoş gəlmisiniz!",
  "internal_error": "Daxili xəta baş verdi. Zəhmət olmasa bir azdan yenidən cəhd edin.",
  "db_connection_error": "Məlumat bazası ilə əlaqə qurulmadı.",
  "validation_error": "Yanlış format. Zəhmət olmasa düzgün məlumat daxil edin:",
  "phone_validation_error": "Telefon nömrəsi formatı yanlışdır. Zəhmət olmasa düzgün nömrə daxil edin:",
  "number_validation_error": "Rəqəm daxil etməlisiniz:",
  "fsm_config_error": "Formanın konfiqurasiyasında xəta baş verdi.",
  "fsm_step_error": "Forma doldurma prosesində xəta baş verdi.",
  "fsm_default_prompt": "Zəhmət olmasa tələb olunan məlumatı daxil edin:",
  "fsm_thanks_default": "Müraciətiniz qəbul olundu. Təşəkkür edirik!"
}
EOF

# i18n/en.json
cat << 'EOF' > "$PROJECT_DIR/i18n/en.json"
{
  "welcome": "Welcome!",
  "internal_error": "An internal error occurred. Please try again later.",
  "db_connection_error": "Database connection is not available.",
  "validation_error": "Invalid format. Please enter valid information:",
  "phone_validation_error": "Invalid phone number format. Please enter a valid number:",
  "number_validation_error": "You must enter a number:",
  "fsm_config_error": "An error occurred in form configuration.",
  "fsm_step_error": "An error occurred during the form filling process.",
  "fsm_default_prompt": "Please provide the required information:",
  "fsm_thanks_default": "Your request has been submitted. Thank you!"
}
EOF
# TODO: Добавить другие языки и локализовать ВСЕ системные сообщения.

log "SUCCESS" "Файлы локализации созданы/обновлены."

log "INFO" "Запуск скрипта настройки AI Agent Platform (Merged MVP) - Часть 2: Создание Core файлов (конфиг, БД, процессор, роутер, клиент n8n, i18n)..."

# --- Add Content to Files (Part 2 - Core) ---

log "INFO" "Наполнение файла core/config.py..."
# core/config.py (from first script, updated for second script's settings + i18n)
cat << 'EOF' > "$PROJECT_DIR/core/config.py"
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
from loguru import logger

# Базовые настройки приложения
APP_NAME = "ai_agent_platform_merged"
APP_VERSION = "0.2.1" # Обновленная версия после Части 2

# Настройки MongoDB
MONGO_URI = os.getenv("MONGO_URI", "mongodb://mongodb:27017/ai_agent") # URL подключения к MongoDB
MONGO_DB_NAME = os.getenv("MONGO_DB_NAME", "ai_agent") # Название базы данных

# Настройки n8n
N8N_URL = os.getenv("N8N_URL", "http://n8n:5678") # URL сервиса n8n
N8N_BASIC_AUTH_USER = os.getenv("N8N_BASIC_AUTH_USER", "admin") # Пользователь для Basic Auth n8n
N8N_BASIC_AUTH_PASSWORD = os.getenv("N8N_BASIC_AUTH_PASSWORD", "secure-n8n-password") # Пароль для Basic Auth n8n

# Настройки OpenRouter (LLM)
OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY", "your-openrouter-api-key") # API ключ OpenRouter
DEFAULT_LLM_MODEL = os.getenv("DEFAULT_LLM_MODEL", "deepseek/deepseek-chat") # Модель LLM по умолчанию

# Настройки повторных попыток (Tenacity)
TENACITY_STOP_AFTER_ATTEMPTS = int(os.getenv("TENACITY_STOP_AFTER_ATTEMPTS", "5")) # Макс. попыток повтора
TENACITY_WAIT_FIXED_SECONDS = int(os.getenv("TENACITY_WAIT_FIXED_SECONDS", "3")) # Пауза между попытками

# Настройки логирования (Loguru)
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO").upper() # Уровень логирования (DEBUG, INFO, WARNING, ERROR)
LOG_FORMAT = "<green>{time:YYYY-MM-DD HH:mm:ss.SSS}</green> | <level>{level: <8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - <level>{message}</level>" # Формат логов

# Настройки мультиязычности (i18n)
I18N_PATH = os.getenv("I18N_PATH", "i18n") # Путь к директории с файлами локализации (относительно рабочей директории)
DEFAULT_LANG = os.getenv("DEFAULT_LANG", "en") # Язык по умолчанию, если не удалось определить язык пользователя

# Настройки Dev GUI
FLASK_SECRET_KEY = os.getenv("FLASK_SECRET_KEY", "super-secret-key-default") # Секретный ключ для Flask сессий Dev GUI
EDITOR_USER = os.getenv("EDITOR_USER", "admin") # Пользователь для аутентификации Dev GUI
EDITOR_PASSWORD = os.getenv("EDITOR_PASSWORD", "admin123") # Пароль для аутентификации Dev GUI


# Настройка логирования Loguru
def setup_logging():
    """Настраивает обработчики логирования Loguru."""
    # Удаление стандартного обработчика (например, stdout)
    logger.remove()

    # Добавление обработчика для вывода в консоль
    logger.add(
        sys.stdout,
        format=LOG_FORMAT,
        level=LOG_LEVEL,
        colorize=True # Включает цвета в консоли
    )

    # Добавление обработчика для записи логов в файл
    # TODO: Сделать путь к файлу логов настраиваемым через переменную окружения?
    logger.add(
        "logs/app.log", # Путь к файлу логов
        rotation="10 MB", # Ротация файла при достижении 10MB
        retention="7 days", # Хранить логи 7 дней
        format=LOG_FORMAT,
        level=LOG_LEVEL,
        compression="zip" # Сжимать старые файлы логов
    )

    logger.info(f"Логирование настроено с уровнем {LOG_LEVEL}")


# Проверка обязательных переменных окружения
def validate_env():
    """Проверяет наличие критически важных переменных окружения."""
    required_vars = [
        "OPENROUTER_API_KEY", # API ключ LLM - критичен для работы ядра
        "CLIENT_ID", # ID клиента - критичен для запуска main.py
        # N8N_URL, N8N_BASIC_AUTH_USER, N8N_BASIC_AUTH_PASSWORD # Важны для отправки в n8n, но с дефолтами
        # MONGO_URI, MONGO_DB_NAME # Важны для БД, но с дефолтами
    ]

    missing_vars = []
    for var_name in required_vars:
        # Получаем значение переменной окружения
        value = os.getenv(var_name)
        # Проверяем, что оно не None и не пустая строка
        if not value:
            missing_vars.append(var_name)

    if missing_vars:
        # Если есть отсутствующие критичные переменные, логируем ошибку
        logger.critical(f"Отсутствуют критически важные переменные окружения: {', '.join(missing_vars)}")
        logger.critical("Приложение не может быть запущено без этих переменных.")
        sys.exit(1) # Завершаем работу приложения

    # Дополнительная проверка для OpenRouter API ключа (если он остался дефолтным)
    if OPENROUTER_API_KEY == "your-openrouter-api-key":
         logger.warning("Используется значение по умолчанию для OPENROUTER_API_KEY. LLM вызовы не будут работать.")

# Note: validate_env() вызывается в main.py после загрузки переменных окружения из .env

EOF

log "SUCCESS" "core/config.py создан/обновлен."


log "INFO" "Наполнение файла core/database.py (Исправлена схема истории)..."
# core/database.py (Fixed History Schema, Updated Indexes, Simplified Base Data)
cat << 'EOF' > "$PROJECT_DIR/core/database.py"
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import asyncio
from datetime import datetime, timezone
import motor.motor_asyncio
from loguru import logger # Используем loguru

# Импорт конфигурации
from core.config import MONGO_URI, MONGO_DB_NAME

# Глобальные переменные для доступа к базе данных
client = None
db = None

async def init_db():
    """
    Инициализация подключения к базе данных MongoDB, создание необходимых индексов
    и добавление базовых данных (например, шаблон промпта 'generic', дефолтная маршрутизация n8n).
    Использует логику повторных попыток подключения.
    """
    global client, db

    # Параметры повторных попыток подключения к БД
    max_retries = 10
    retry_delay_seconds = 5
    
    # Цикл повторных попыток подключения
    for i in range(max_retries):
        try:
            # Если клиент и база данных уже инициализированы, проверяем работоспособность соединения
            if client is not None and db is not None:
                 try:
                      await client.admin.command('ping') # Проверка соединения
                      logger.info("MongoDB клиент уже инициализирован и соединение активно.")
                      return True # Если соединение активно, выходим из функции
                 except Exception:
                      # Если проверка активного соединения не удалась, сбрасываем клиент и пробуем переподключиться
                      logger.warning("Существующее соединение MongoDB неактивно. Попытка переподключения.")
                      client = None
                      db = None


            logger.info(f"Попытка подключения к MongoDB {i+1}/{max_retries}: {MONGO_URI}...")
            
            # Создаем новый клиент Motor с таймаутом выбора сервера
            client = motor.motor_asyncio.AsyncIOMotorClient(MONGO_URI, serverSelectionTimeoutMS=5000) # Таймаут 5 секунд

            # Пингуем базу данных для проверки, что соединение работает
            await client.admin.command('ping')
            db = client[MONGO_DB_NAME] # Получаем объект базы данных по имени из MONGO_URI
            
            logger.success("Успешное подключение к MongoDB.")
            
            # Создаем необходимые индексы
            await create_indexes()
            
            # Инициализируем базовые данные (generic промпты, default n8n routing)
            await init_base_data()
            
            return True # Подключение и инициализация успешны, выходим из функции

        except Exception as e:
            # Логируем ошибку подключения
            logger.warning(f"Подключение к MongoDB не удалось (Попытка {i+1}/{max_retries}): {e}")
            if i < max_retries - 1:
                # Если есть еще попытки, ждем и пробуем снова
                logger.info(f"Повторная попытка подключения через {retry_delay_seconds} секунд...")
                await asyncio.sleep(retry_delay_seconds)
            else:
                # Если попытки исчерпаны, логируем критическую ошибку и выходим.
                logger.critical(f"Не удалось подключиться к MongoDB после {max_retries} попыток. Завершение работы.", exc_info=True)
                # В продакшене, возможно, стоит продолжать попытки или реализовать более сложное восстановление.
                return False # Возвращаем False, чтобы вызывающий код знал, что соединение не установлено.

async def create_indexes():
    """Создание необходимых индексов в базе данных."""
    # Проверяем, доступен ли объект базы данных
    if db is None:
        logger.error("Объект базы данных недоступен для создания индексов.")
        return # Не можем создать индексы без подключения к БД.

    logger.info("Проверка/создание индексов в базе данных...")
    
    try:
        # clients: Хранит конфигурации клиентов
        await db.clients.create_index([("client_id", 1)], unique=True)
        logger.debug("Индекс на 'clients.client_id' проверен/создан.")

        # dialogs: Хранит историю диалогов (сообщения пользователя и бота)
        # Индекс для эффективного получения истории для конкретного пользователя/треда, сортировка по времени.
        # Включаем platform, thread_id и user_id для точного фильтрации диалогов.
        await db.dialogs.create_index([
            ("client_id", 1),         # Фильтр по клиенту
            ("platform", 1),          # Фильтр по платформе
            ("thread_id", 1),         # Фильтр по треду (если есть)
            ("user_id", 1),           # Фильтр по пользователю
            ("timestamp", 1)          # Сортировка по времени (возрастание)
        ])
        logger.debug("Индекс на 'dialogs' проверен/создан.")

        # stats: Для отслеживания статистики (например, интентов)
        await db.stats.create_index([("client_id", 1), ("platform", 1), ("thread_id", 1), ("user_id", 1)])
        await db.stats.create_index([("client_id", 1), ("intent", 1)]) # Индекс для агрегации по интентам
        logger.debug("Индексы на 'stats' проверены/созданы.")

        # forms: Для данных заполненных форм
        await db.forms.create_index([("client_id", 1), ("user_id", 1), ("timestamp", 1)]) # Индекс по пользователю и времени отправки
        await db.forms.create_index([("client_id", 1), ("form_name", 1)]) # Индекс для фильтрации по имени формы
        logger.debug("Индексы на 'forms' проверены/созданы.")

        # destinations: Для данных о направлениях (туризм)
        await db.destinations.create_index([("client_id", 1), ("name", 1)]) # Индекс по клиенту и названию направления
        await db.destinations.create_index([("client_id", 1), ("popularity", -1)]) # Индекс для сортировки по популярности
        logger.debug("Индексы на 'destinations' проверены/созданы.")

        # services: Для данных об услугах (салоны красоты)
        await db.services.create_index([("client_id", 1), ("name", 1)]) # Индекс по клиенту и названию услуги
        await db.services.create_index([("client_id", 1), ("price", 1)]) # Индекс для сортировки по цене (пример)
        logger.debug("Индексы на 'services' проверены/созданы.")


        # config: Для общих настроек (например, ключи доступа, не относящиеся к клиенту) - используем '_id' или 'key'
        # В данном проекте используется 'key' в качестве идентификатора документа
        await db.config.create_index([("key", 1)], unique=True)
        logger.debug("Индекс на 'config.key' проверен/создан.")

        # n8n_routing: Хранит конфигурацию маршрутизации вебхуков n8n по клиентам
        await db.n8n_routing.create_index([("client_id", 1)], unique=True)
        logger.debug("Индекс на 'n8n_routing.client_id' проверен/создан.")

        # webhook_logs: Для аудита вызовов вебхуков n8n и FSM отправки
        await db.webhook_logs.create_index([("timestamp", 1)]) # Сортировка по времени
        await db.webhook_logs.create_index([("client_id", 1)]) # Фильтр по клиенту
        await db.webhook_logs.create_index([("processing_id", 1)]) # Фильтр по ID обработки/отправки
        await db.webhook_logs.create_index([("log_type", 1)]) # Фильтр по типу лога
        logger.debug("Индексы на 'webhook_logs' проверены/созданы.")

        # prompt_templates: Хранит шаблоны промптов для LLM
        await db.prompt_templates.create_index([("business_type", 1)], unique=True)
        logger.debug("Индекс на 'prompt_templates.business_type' проверен/создан.")

        # fsm_state: Хранит персистентное состояние FSM для aiogram.
        # Управляется MongoStorage, но индекс по ключу состояния может быть полезен.
        # Структура ключа в MongoStorage: { "_id": f"{bot_id}:{chat_id}" }
        # MongoStorage сам создает необходимые индексы на _id.
        # Дополнительный индекс здесь не требуется, если только не нужны кастомные запросы.
        # await db.fsm_state.create_index(...) # Индекс коллекции по умолчанию для MongoStorage - 'fsm_state'


    except Exception as e:
        logger.error(f"Ошибка при создании/проверке индексов в БД: {e}", exc_info=True)
        # В продакшене, ошибка создания индексов может быть критичной.
        # Решите, нужно ли завершать приложение в этом случае.
        # Для MVP, просто логируем и продолжаем.

async def init_base_data():
    """
    Инициализация базовых данных в базе (например, шаблон промпта 'generic',
    конфигурация маршрутизации n8n по умолчанию).
    Эти данные добавляются при инициализации БД, если они отсутствуют.
    """
    # Проверяем, доступен ли объект базы данных
    if db is None:
        logger.error("Объект базы данных недоступен для инициализации базовых данных.")
        return # Не можем инициализировать без подключения к БД.

    logger.info("Инициализация базовых данных (generic промпты, default n8n routing)...")

    # --- Создание шаблона промпта по умолчанию ('generic') ---
    # Этот шаблон - основа для стратегии "LLM-First". Он инструктирует LLM выводить JSON.
    # Проверяем, существует ли документ с business_type="generic"
    default_prompt_exists = await db.prompt_templates.count_documents({"business_type": "generic"})

    if default_prompt_exists == 0:
        logger.info("Шаблон промпта 'generic' не найден. Создание дефолтного шаблона...")

        # Это СИСТЕМНЫЙ промпт шаблон. Переменные {business_name}, {business_type}, {platform}, {persona}, {tone}
        # будут подставлены роутером/процессором.
        # История диалога и текущее сообщение пользователя будут переданы ОТДЕЛЬНЫМИ сообщениями в API LLM.
        system_prompt_template = """
Ты - AI-ассистент для бизнеса "{business_name}" в сфере {business_type}.
Твоя главная задача - понять сообщения пользователей, определить их намерение (intent),
извлечь ключевую информацию (entities), предложить возможные действия (actions) для системы,
и сгенерировать дружелюбный ответ пользователю.
Всегда отвечай на том языке, на котором написано текущее сообщение пользователя. Если язык не удалось определить, используй язык по умолчанию.

Всегда возвращай ответ в формате JSON объекта со следующими полями:
{{
  "intent": "...", // Определи основное намерение пользователя. Используй одно из предопределенных значений (greeting, question, booking, info_request, complaint, feedback, price_inquiry, schedule_inquiry, order_status, cancel_request, other) или выведи новое, релевантное типу бизнеса.
  "entities": {{...}}, // Словарь извлеченной информации в формате ключ-значение (например, "service_type": "маникюр", "date": "завтра"). Используй язык пользователя для значений сущностей, если это применимо (названия услуг, местоположения).
  "actions": [...], // Список действий, которые система должна рассмотреть на основе намерения и сущностей.
  "response": "...", // Твой естественный ответ пользователю.
  "language": "..." // **ВАЖНО:** Определи язык ТЕКУЩЕГО сообщения пользователя (например, "az", "en", "ru", "tr").
}}

**Типы действий (actions) для предложения (включай в список, если релевантно):**
- {{"type": "start_fsm", "form_name": "<имя_формы_из_YAML>"}}: Включай это действие, если пользователь явно хочет начать заполнение конкретной формы, например, для бронирования услуги или тура. Имя формы должно совпадать с ключом в секции 'flows' YAML-конфига клиента.
  # TODO: В промпт можно добавить список доступных имен форм для этого клиента, если они известны LLM. Пока это не реализовано.
- {{"type": "notify_manager", "reason": "..."}}: Включай, если пользователю нужна помощь человека или возникла сложная проблема.
- {{"type": "search_kb", "query": "..."}}: Если пользователь задает вопрос, ответ на который можно найти в базе знаний.
- {{"type": "send_info", "info_type": "..."}}: Чтобы запросить отправку предопределенной информации (например, "price_list", "address", "working_hours").
# TODO: Добавить другие действия, специфичные для туризма и салонов красоты, если применимо.

Поддерживай {tone} тон общения и {persona}, соответствующие бизнесу "{business_name}" ({business_type}).
"""
        # Вставляем новый документ в коллекцию 'prompt_templates'
        await db.prompt_templates.insert_one({
            "business_type": "generic",
            "template": system_prompt_template.strip(), # Сохраняем строку шаблона системного промпта
            "created_at": datetime.now(timezone.utc)
        })
        logger.success("Шаблон промпта по умолчанию 'generic' успешно создан.")
    else:
        logger.info("Шаблон промпта 'generic' уже существует.")

    # --- Создание конфигурации маршрутизации n8n по умолчанию ('default') ---
    # Эта конфигурация используется как fallback, если для клиента нет специфичной настройки маршрутизации.
    # Она определяет, куда отправлять результаты LLM по умолчанию в n8n.
    default_n8n_routing_exists = await db.n8n_routing.count_documents({"client_id": "default"})

    if default_n8n_routing_exists == 0:
         logger.info("Конфигурация маршрутизации n8n по умолчанию 'default' не найдена. Создание...")
         # Вставляем новый документ в коллекцию 'n8n_routing'
         await db.n8n_routing.insert_one({
            "client_id": "default",
            "default_webhook": "webhook/default", # Путь вебхука по умолчанию в n8n (например, http://n8n:5678/webhook/default)
            "use_intent_routing": False, # По умолчанию маршрутизация по интенту выключена
            "intent_routes": {}, # Словарь {intent: webhook_path}
            "created_at": datetime.now(timezone.utc)
        })
         logger.success("Конфигурация маршрутизации n8n по умолчанию 'default' успешно создана.")
    else:
        logger.info("Конфигурация маршрутизации n8n 'default' уже существует.")

    # --- Другая потенциальная инициализация базовых данных ---
    # Здесь можно добавить создание других базовых данных, которые должны существовать при запуске.
    # Например, предопределенные услуги или направления, если они не загружаются из CSV/скриптами управления.

    logger.info("Инициализация базовых данных завершена.")


def get_database():
    """
    Получение объекта базы данных.
    Предполагается, что init_db() уже была успешно вызвана.
    Проверяет активность соединения (базово).
    """
    # Если глобальный объект db не установлен (init_db не вызывался или провалился)
    if db is None:
        logger.error("Попытка получить объект базы данных до успешной инициализации init_db(). Возврат None.")
        # В зависимости от контекста, можно выбросить исключение, но возврат None позволяет вызывающему коду обработать это.
        return None
    
    # Базовая проверка активности соединения Motor клиента
    try:
        # Motor клиент управляет пулом соединений. Ping - легкая проверка.
        # В реальной ситуации может потребоваться более надежный механизм проверки или переподключения.
        client.admin.command('ping')
        # Если пинг успешен, возвращаем объект базы данных.
        return db
    except Exception as e:
        # Если пинг не удался, соединение, вероятно, потеряно.
        logger.error(f"Соединение с базой данных потеряно: {e}. Объект DB может быть устаревшим.", exc_info=True)
        # Возвращаем None или устаревший объект db? Возврат None более явно указывает на проблему.
        # В более сложной системе, здесь может быть логика переподключения.
        return None # Возвращаем None, чтобы вызывающий код обрабатывал отсутствие соединения.

# Note: init_mongo.py теперь фокусируется на вставке данных клиентов/туров/услуг.
# main.py вызовет init_db() при старте, чтобы обеспечить индексы и базовые данные.
```

log "SUCCESS" "core/database.py создан/обновлен."

log "INFO" "Запуск скрипта настройки AI Agent Platform (Merged MVP) - Часть 3: Создание UI/Adapter файлов и Dev GUI..."

# --- Add Content to Files (Part 3 - UI and Dev GUI) ---

log "INFO" "Наполнение файла ui/telegram_bot/main.py..."
# ui/telegram_bot/main.py (from second script, updated imports/calls, state management, pass lang)
cat << 'EOF' > "$PROJECT_DIR/ui/telegram_bot/main.py"
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging # Используем loguru вместо стандартного logging
from aiogram.enums import ParseMode # Для форматирования сообщений (например, HTML)
from aiogram import Bot, Dispatcher # Классы Bot и Dispatcher aiogram
# from aiogram.fsm.storage.memory import MemoryStorage # Исходное хранилище в памяти (удалено)
# from aiogram.fsm.storage.mongo import MongoStorage # Импортируем MongoStorage
# from aiogram.fsm.storage.base import BaseStorage # Для указания типа хранилища (для типизации)
from motor_fsm_storage.storage import MongoStorage # Импортируем MongoStorage из нужной библиотеки
from aiogram.fsm.context import FSMContext # Для управления состоянием FSM
from aiogram.fsm.state import State, StatesGroup # Для определения состояний FSM
from aiogram.types import Message # Тип входящего сообщения Telegram
import asyncio # Для асинхронности
import os # Для чтения переменных окружения

# Импортируем класс Router и функцию setup_logging из ядра
# setup_logging() вызывается в main.py перед запуском адаптеров
logger = logging.getLogger(__name__) # Получаем логгер loguru

# Импортируем I18nLoader для доступа к локализованным строкам (если нужно в адаптере)
from core.i18n import I18nLoader
# Импортируем Router для type hinting
from core.router import Router


# Определяем состояния FSM для форм.
# Имя класса "FormState" и имя состояния "FormState:waiting_for_field"
# должны быть консистентны с тем, что проверяется в core/router.py.
class FormState(StatesGroup):
    waiting_for_field = State() # Состояние ожидания ввода для поля формы


async def start_telegram(client_id: str, router: Router, storage: MongoStorage, i18n: I18nLoader, telegram_token: str):
    """
    Инициализирует и запускает поллер Telegram бота для конкретного клиента.

    Args:
        client_id: ID клиента, который обслуживает этот адаптер.
        router: Экземпляр core.router.Router для обработки сообщений.
        storage: Экземпляр персистентного хранилища состояний FSM (MongoStorage).
        i18n: Экземпляр I18nLoader для локализации (если адаптеру нужны системные сообщения).
        telegram_token: API токен для Telegram бота.
    """
    if not telegram_token:
        # Используем i18n для логирования ошибки, если загрузчик доступен
        error_msg = i18n.get("telegram_token_missing_error", i18n.default_lang, f"TELEGRAM_TOKEN not set for client {client_id}. Telegram adapter will not start.")
        logger.error(error_msg)
        # Если токен отсутствует, просто выходим из функции, не запуская адаптер.
        return

    logger.info(f"Попытка запуска адаптера Telegram для клиента {client_id}...")

    try:
        # Создаем экземпляр бота и диспетчера, связывая хранилище с диспетчером
        bot = Bot(token=telegram_token, parse_mode=ParseMode.HTML) # Используем HTML для форматирования
        dp = Dispatcher(storage=storage) # Передаем персистентное хранилище в диспетчер

        # Сохраняем необходимые объекты (роутер, client_id, i18n) в контексте диспетчера.
        # Это позволяет обработчикам сообщений (on_message) получить к ним доступ.
        dp["router"] = router
        dp["client_id"] = client_id
        dp["i18n"] = i18n # Передаем загрузчик локализации в контекст

        @dp.message()
        async def on_message(message: Message, state: FSMContext):
            """Обработчик всех входящих сообщений."""
            # Получаем необходимые объекты из контекста диспетчера
            current_client_id: str = dp["client_id"]
            router_instance: Router = dp["router"]
            i18n_loader: I18nLoader = dp["i18n"] # Получаем загрузчик локализации

            user_id = str(message.from_user.id) # Уникальный ID пользователя Telegram
            text = message.text # Текст сообщения

            # Определяем язык пользователя. Для Telegram можем использовать language_code.
            # Fallback на дефолтный язык приложения, если language_code отсутствует.
            # Этот язык будет передан в роутер и использован для системных сообщений FSM и i18n логирования.
            # LLM самостоятельно определяет язык для своего ответа.
            user_lang = message.from_user.language_code or i18n_loader.default_lang

            # В Telegram, user_id для 1:1 чатов часто совпадает с thread_id (chat.id)
            thread_id = str(message.chat.id)


            if text is None: # Обрабатываем нетекстовые сообщения (фото, стикеры, и т.д.)
                # TODO: Решить, как обрабатывать нетекстовые сообщения.
                # Ответить предопределенным сообщением? Сохранить в историю с пометкой? Попросить пользователя написать текстом?
                logger.info(f"Получено нетекстовое сообщение от {user_id} в чате {thread_id} для клиента {current_client_id}.")
                # Используем i18n для ответа пользователю
                response_text = i18n_loader.get("non_text_message_response", user_lang, "Извините, я пока умею обрабатывать только текстовые сообщения.") # TODO: Добавить ключ в i18n файлы
                asyncio.create_task(message.answer(response_text, parse_mode=ParseMode.HTML))
                # TODO: Сохранить в историю факт получения нетекстового сообщения?
                return

            logger.info(f"Telegram message от {user_id} в чате {thread_id} ({current_client_id}): {text[:70]}{'...' if len(text)>70 else ''}")

            # Получаем текущее состояние FSM для этого пользователя/чата.
            # state объект передается aiogram. Состояние хранится в переданном MongoStorage.
            current_state = await state.get_state()

            # Вызываем основной метод роутера для обработки сообщения.
            # Роутер сам решит, FSM это ввод или новый запрос для LLM.
            # Роутер вернет текст ответа, который мы отправим пользователю.

            # Передаем все необходимые данные в роутер, включая объект состояния FSM.
            # Передаем user_lang для использования роутером в системных сообщениях FSM и i18n логировании.
            response_text = await router_instance.process_inbound_message(
                 client_id=current_client_id,
                 user_id=user_id, # ID пользователя
                 text=text,
                 platform="telegram", # Указываем платформу
                 state=state, # Передаем объект состояния FSM aiogram для пользователя
                 thread_id=thread_id, # Передаем ID треда/диалога
                 message_data=message.model_dump_json(), # Передаем сырые данные сообщения (опционально)
                 # Язык передается в state при инициации FSM, а также может быть передан в router для i18n логирования.
                 # Для простоты, lang уже передается в process_fsm_input роутером из state.
                 # Для LLM части роутер может использовать язык, определенный LLM.
             )

            # Отправляем полученный от роутера текст ответа пользователю
            if response_text:
                # Используем asyncio.create_task, чтобы не блокировать обработчик поллера,
                # если отправка сообщения займет время.
                asyncio.create_task(message.answer(response_text, parse_mode=ParseMode.HTML)) # Отправляем ответ с HTML форматированием
            else:
                 logger.warning(f"Роутер вернул пустой ответ для пользователя {user_id} в чате {thread_id} клиента {current_client_id}.")


        # Запускаем цикл поллинга бота.
        logger.info(f"Запуск поллера Telegram бота для клиента {client_id}...")
        # start_polling - это асинхронная функция, которая блокирует выполнение до отмены.
        await dp.start_polling(bot)
        logger.info(f"Поллер Telegram бота остановлен для клиента {client_id}.")

    except Exception as e:
        # Логируем ошибку в адаптере
        logger.error(f"Ошибка в адаптере Telegram для клиента {client_id}: {e}", exc_info=True)
        # Пробрасываем исключение дальше в main(), чтобы оно было замечено.
        raise


# Пример запуска адаптера (вызывается из main.py)
# if __name__ == "__main__":
#     # При автономном запуске необходимо настроить логирование, создать Router, Storage, I18nLoader
#     # и передать их сюда, а также получить токен из окружения или конфига.
#     # Например:
#     # asyncio.run(async_main_for_standalone_adapter_test()) # Нужна обертка для async

EOF

log "SUCCESS" "ui/telegram_bot/main.py создан/обновлен."


log "INFO" "Наполнение файла ui/whatsapp_evolution/main.py..."
# ui/whatsapp_evolution/main.py (from second script, updated imports/calls, state management, i18n)
cat << 'EOF' > "$PROJECT_DIR/ui/whatsapp_evolution/main.py"
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import asyncio
import logging # Используем loguru
import httpx # Для отправки сообщений через Evolution API
from aiohttp import web # Для приема вебхуков и запуска веб-сервера
# from core.router import process_inbound_message, process_fsm_input # Импортируем Router класс
from aiogram.fsm.context import FSMContext # Для управления состоянием FSM
# from aiogram.fsm.storage.memory import MemoryStorage # Заменяем на MongoStorage
# from aiogram.fsm.storage.base import BaseStorage # Для указания типа хранилища
from motor_fsm_storage.storage import MongoStorage # Импортируем MongoStorage из нужной библиотеки

# Импортируем Router класс для type hinting
from core.router import Router 

# Предполагаем, что loguru настроен в core.config или main.py
logger = logging.getLogger(__name__) # Получаем логгер loguru

# Импортируем I18nLoader для доступа к локализованным строкам (если нужно в адаптере)
from core.i18n import I18nLoader


# --- Управление состоянием FSM для aiohttp ---
# Поскольку aiohttp не имеет встроенного механизма FSM, используем aiogram.fsm
# с персистентным хранилищем MongoStorage.
# Экземпляр хранилища FSM будет передан в функцию start_whatsapp
# и сохранен в контексте приложения aiohttp.

async def get_fsm_context(request: web.Request, user_id: str):
    """
    Получает или создает FSMContext для данного пользователя в этом адаптере,
    используя хранилище из контекста запроса aiohttp.
    Использует уникальный ключ для каждого пользователя WhatsApp.
    """
    # Получаем хранилище из контекста приложения aiohttp (сохранено при старте)
    storage: MongoStorage = request.app["storage"]

    # Ключ для уникальной идентификации контекста пользователя в хранилище.
    # Используем кортеж: (название адаптера, ID пользователя WhatsApp).
    fsm_key = ("whatsapp", str(user_id))

    # FSMContext требует bot_id и chat_id. Для не-Telegram адаптеров это могут быть произвольные строки.
    # Используем client_id и user_id для уникальности в рамках хранилища.
    bot_id = request.app["client_id"] # Используем client_id как bot_id
    chat_id = user_id # Используем user_id как chat_id

    # Создание экземпляра FSMContext.
    return FSMContext(storage=storage, key=fsm_key, bot_id=bot_id, chat_id=chat_id)


# --- Взаимодействие с Evolution API ---
async def send_message_evolution(phone: str, message: str, api_url: str, api_key: str):
    """Отправляет текстовое сообщение, используя Evolution API."""
    if not api_url or not api_key:
         logger.error("Evolution API URL или Key не установлены. Невозможно отправить сообщение.")
         return # Не можем отправить сообщение

    # Предполагаем использование инстанса 'default' в Evolution API
    send_url = f"{api_url.rstrip('/')}/message/sendText/default"
    headers = {"apikey": api_key}
    payload = {"number": phone, "text": message}

    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(send_url, json=payload, headers=headers)
            response.raise_for_status() # Выбросит HTTPStatusError для плохих ответов (4xx/5xx)
            logger.success(f"Сообщение успешно отправлено через Evolution API на номер {phone}. Статус: {response.status_code}")
            # logger.debug(f"Ответ Evolution API: {response.json()}") # Логирование деталей ответа
            return response.json() # Возвращаем ответ Evolution API
    except httpx.HTTPStatusError as e:
        logger.error(f"HTTP ошибка Evolution API при отправке сообщения на номер {phone}: {e.response.status_code} - {e.response.text[:200]}", exc_info=True)
        # Пробрасываем исключение, чтобы вызывающий код мог его обработать (хотя в этом адаптере мы его не перехватываем)
        # В реальной ситуации, возможно, нужна логика повторных попыток отправки здесь.
        raise
    except Exception as e:
        logger.error(f"Ошибка Evolution API при отправке сообщения на номер {phone}: {e}", exc_info=True)
        # Пробрасываем исключение.
        raise


# --- Обработчик Webhook (aiohttp) ---
async def webhook_handler(request: web.Request):
    """Обрабатывает входящие вебхуки от Evolution API."""
    # Получаем необходимые объекты из контекста приложения aiohttp (сохранены при старте)
    client_id = request.app["client_id"]
    router: Router = request.app["router"] # Экземпляр Router
    evolution_api_url = request.app["api_url"]
    evolution_api_key = request.app["api_key"]
    i18n_loader: I18nLoader = request.app["i18n"] # Получаем загрузчик локализации

    try:
        # Парсим входящие данные вебхука (ожидаем JSON)
        data = await request.json()
        # Логируем входящий вебхук (без чувствительных данных)
        logger.debug(f"Получен WhatsApp вебхук для клиента {client_id}. Тип: {data.get('event')}. ID сообщения: {data.get('message', {}).get('id')}")
        # logger.debug(f"Полные данные вебхука: {data}") # Осторожно: может содержать приватные данные!

        # --- Парсинг входящего сообщения из данных Evolution API ---
        # Точная структура зависит от событий вебхука Evolution API.
        # Предполагаем, что входящее сообщение находится в поле 'message'.
        # Ожидаем текстовое сообщение в 'message.text.body' и отправителя в 'message.from'.

        message_data = data.get("message")
        # Проверяем, что это сообщение и оно текстовое
        if not message_data or message_data.get("type") != "text" or not message_data.get("text", {}).get("body"):
             logger.debug(f"Пропущено: Вебхук не содержит текстовое сообщение или имеет неподдерживаемый формат ({data.get('type')}) для клиента {client_id}. ")
             return web.Response(text="OK") # Подтверждаем получение даже некорректных данных

        message_text = message_data["text"]["body"] # Текст сообщения
        user_id = message_data.get("from") # ID пользователя/номер телефона WhatsApp
        message_id = message_data.get("id") # ID сообщения в Evolution API
        message_timestamp = message_data.get("timestamp") # Unix timestamp сообщения

        if not user_id or not message_text:
             logger.warning(f"Пропущено: Вебхук содержит сообщение без user ID ('from') или текста ('text.body') для клиента {client_id}. Данные: {data}")
             return web.Response(text="OK") # Подтверждаем получение

        platform = "whatsapp" # Указываем платформу

        # Для 1:1 чатов WhatsApp, user_id часто используется как thread_id
        thread_id = user_id

        # --- Получаем FSM Context для пользователя ---
        # Используем get_fsm_context для получения/создания контекста FSM для этого пользователя
        # request объект необходим для доступа к storage через request.app["storage"]
        state = await get_fsm_context(request, user_id)

        # --- Определяем язык пользователя ---
        # WhatsApp API не предоставляет язык пользователя напрямую в вебхуках по умолчанию.
        # LLM в CoreProcessor будет определять язык входящего сообщения.
        # Для системных сообщений, Роутер использует язык из FSM state или дефолтный.
        # Здесь мы не передаем определенный язык явно в process_inbound_message,
        # Роутер будет использовать язык из state (если FSM активен) или дефолтный.
        # Более продвинутая реализация может попытаться определить язык здесь (например, простой либой)
        # и передать его в роутер.


        # --- Обрабатываем Сообщение ---
        # Вызываем основной метод роутера для обработки сообщения.
        # Роутер сам определит, находится ли пользователь в FSM или это новый запрос для LLM.
        # Роутер вернет текст ответа, который нужно отправить пользователю.

        response_text = await router.process_inbound_message(
             client_id=client_id,
             user_id=user_id,
             text=message_text,
             platform=platform,
             state=state, # Передаем объект состояния FSM
             thread_id=thread_id, # Передаем ID треда/диалога
             message_data=data # Передаем сырые данные вебхука для отладки в ядре, если нужно
             # Язык не передаем явно, Роутер определит его для системных сообщений.
         )

        # Отправляем текст ответа, полученный от роутера, обратно пользователю через Evolution API
        if response_text:
            # Используем asyncio.create_task, чтобы не блокировать обработчик вебхука
            # и быстро отправить ответ 200 OK в Evolution API.
            # Evolution API будет обрабатывать отправку сообщения в фоне.
            logger.info(f"Отправка ответа пользователю {user_id} ({client_id}) через Evolution API: {response_text[:70]}{'...' if len(response_text)>70 else ''}")
            asyncio.create_task(send_message_evolution(user_id, response_text, evolution_api_url, evolution_api_key))
        else:
             logger.warning(f"Роутер вернул пустой ответ для пользователя {user_id} клиента {client_id}.")


        # --- Подтверждение Вебхука ---
        # Evolution API ожидает ответ 200 OK для подтверждения получения вебхука.
        # Возвращаем OK сразу, независимо от результата внутренней обработки (она происходит асинхронно).
        return web.Response(text="OK")

    except Exception as e:
        # Логируем ошибку обработки вебхука. Используем i18n для текста ошибки в логе.
        error_msg = i18n_loader.get("webhook_process_error", i18n_loader.default_lang, "Error processing webhook") # TODO: Добавить ключ в i18n
        logger.error(f"{error_msg} для клиента {client_id}: {e}", exc_info=True)
        # Даже в случае ошибки, лучше вернуть 200 OK источнику вебхука (Evolution API),
        # чтобы он не пытался повторить отправку постоянно. Ошибки должны обрабатываться внутри.
        # Можно вернуть 500, если вы уверены, что Evolution API правильно обработает это.
        # Для MVP и большинства вебхуков, возврат 200 OK безопаснее.
        return web.Response(text="Error processing webhook", status=500) # Возвращаем 500 для сигнала об ошибке


async def start_whatsapp(client_id: str, router: Router, storage: MongoStorage, i18n: I18nLoader, api_url: str, api_key: str, webhook_base_url: str, internal_port: int):
    """
    Инициализирует слушатель вебхуков WhatsApp (Evolution API) и регистрирует вебхук.

    Args:
        client_id: ID клиента.
        router: Экземпляр core.router.Router.
        storage: Экземпляр персистентного хранилища состояний FSM (MongoStorage).
        i18n: Экземпляр I18nLoader для локализации.
        api_url: Базовый URL сервиса Evolution API (например, http://evolution-api:8080).
        api_key: API ключ для Evolution API.
        webhook_base_url: Внешний URL, по которому доступен вебхук-сервер ЭТОГО адаптера
                          (например, http://ai_agent:8080 - внутренний Docker адрес).
        internal_port: Порт, который СЛУШАЕТ aiohttp сервер ЭТОГО адаптера внутри контейнера.
    """
    if not api_url or not api_key or not webhook_base_url or not internal_port:
        error_msg = i18n.get("whatsapp_config_missing_error", i18n.default_lang, f"Evolution API settings incomplete for client {client_id}. WhatsApp adapter will not start.") # TODO: Добавить ключ в i18n
        logger.error(error_msg)
        return # Пропускаем запуск, если настройки неполные

    logger.info(f"Попытка запуска адаптера WhatsApp (Evolution API) для клиента {client_id}...")

    # --- Настройка Web-сервера aiohttp ---
    app = web.Application()
    # Сохраняем необходимые объекты в экземпляре приложения aiohttp для доступа из обработчиков вебхуков.
    app["client_id"] = client_id
    app["router"] = router
    app["storage"] = storage # Сохраняем хранилище в контексте приложения
    app["i18n"] = i18n # Сохраняем загрузчик i18n в контексте приложения
    app["api_url"] = api_url
    app["api_key"] = api_key

    # Добавляем маршрут для вебхука.
    # Используем уникальный путь на основе client_id.
    webhook_internal_path = f"/webhook/{client_id}" # Уникальный путь вебхука внутри адаптера ai_agent
    app.add_routes([web.post(webhook_internal_path, webhook_handler)])

    # --- Регистрация Webhook с Evolution API ---
    # Формируем полный URL вебхука, на который Evolution API должен отправлять сообщения.
    # Этот URL должен быть доступен из контейнера evolution_api (или извне, если evolution_api внешний).
    # Предполагаем, что evolution_api и ai_agent находятся в одной Docker сети
    # и evolution_api обращается к ai_agent по его service name (ai_agent) и внутреннему порту (internal_port).
    full_webhook_url_for_evolution = f"{webhook_base_url.rstrip('/')}{webhook_internal_path}" # e.g. http://ai_agent:8080/webhook/green_travel

    # Используем httpx для регистрации URL вебхука в Evolution API
    # Endpoint и структура полезной нагрузки зависят от документации Evolution API.
    registration_url = f"{api_url.rstrip('/')}/webhook"
    registration_payload = {"url": full_webhook_url_for_evolution}
    headers = {"apikey": api_key}

    try:
        logger.info(f"Регистрация вебхука в Evolution API: {full_webhook_url_for_evolution} для клиента {client_id}...")
        async with httpx.AsyncClient(timeout=30.0) as client:
            # Evolution API может вернуть 409 (Conflict), если вебхук уже зарегистрирован.
            response = await client.post(registration_url, json=registration_payload, headers=headers)
            response.raise_for_status() # Выбросит HTTPStatusError для 4xx/5xx
            logger.success(f"Вебхук успешно зарегистрирован в Evolution API по адресу: {full_webhook_url_for_evolution} для клиента {client_id}.")
            # logger.debug(f"Ответ регистрации вебхука Evolution API: {response.json()}") # Логирование ответа
    except httpx.HTTPStatusError as e:
        # Обрабатываем 409 (Conflict) как специальный случай
        if e.response.status_code == 409:
            logger.warning(f"Вебхук {full_webhook_url_for_evolution} уже зарегистрирован в Evolution API для клиента {client_id}. Продолжаем.")
        else:
            # Логируем ошибку регистрации вебхука с использованием i18n
            error_msg = i18n.get("whatsapp_webhook_registration_error", i18n.default_lang, "Failed to register webhook with Evolution API") # TODO: Добавить ключ в i18n
            logger.error(f"{error_msg}: {e.response.status_code} - {e.response.text[:200]}", exc_info=True)
            # В зависимости от критичности, можно пробросить исключение дальше
            # raise # Решите, нужно ли это останавливать приложение

    except Exception as e:
        # Логируем другие ошибки при регистрации вебхука
        error_msg = i18n.get("whatsapp_webhook_registration_error", i18n.default_lang, "Failed to register webhook with Evolution API") # TODO: Добавить ключ в i18n
        logger.error(f"{error_msg}: {e}", exc_info=True)
        # raise # Решите, нужно ли это останавливать приложение


    # --- Запуск Web-сервера aiohttp ---
    runner = web.AppRunner(app)
    await runner.setup()
    # Сайт привязывается к IP и порту. Слушаем на 0.0.0.0, чтобы быть доступными внутри Docker сети.
    site = web.TCPSite(runner, "0.0.0.0", internal_port)
    logger.info(f"Запуск слушателя вебхуков WhatsApp на внутреннем порту {internal_port} для клиента {client_id}")
    await site.start()

    # Адаптер должен продолжать работать и слушать вебхуки.
    # Эта задача будет работать бесконечно, пока не будет отменена (например, при остановке контейнера).
    await asyncio.Event().wait()
    logger.info(f"Слушатель вебхуков WhatsApp остановлен для клиента {client_id}")


# Пример запуска адаптера (вызывается из main.py)
# if __name__ == "__main__":
#     # При автономном запуске необходимо настроить логирование, создать Router, Storage, I18nLoader
#     # и передать их сюда, а также получить настройки API из окружения или конфига.
#     # Например:
#     # asyncio.run(async_main_for_standalone_adapter_test()) # Нужна обертка для async

EOF

log "SUCCESS" "ui/whatsapp_evolution/main.py создан/обновлен."


log "INFO" "Наполнение файла ui/instagram/main.py..."
# ui/instagram/main.py (from second script, updated imports/calls, state management, i18n)
cat << 'EOF' > "$PROJECT_DIR/ui/instagram/main.py"
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import asyncio
import logging # Используем loguru
from instagrapi import Client # Библиотека для работы с Instagram API
from instagrapi.exceptions import ClientError, ChallengeRequired, LoginRequired # Импорт исключений Instagrapi
# from core.router import process_inbound_message # Импортируем Router класс
from aiogram.fsm.context import FSMContext # Для управления состоянием FSM
# from aiogram.fsm.storage.memory import MemoryStorage # Заменяем на MongoStorage
# from aiogram.fsm.storage.base import BaseStorage # Для указания типа хранилища
from motor_fsm_storage.storage import MongoStorage # Импортируем MongoStorage из нужной библиотеки

# Импортируем Router класс для type hinting
from core.router import Router

# Предполагаем, что loguru настроен в core.config или main.py
logger = logging.getLogger(__name__) # Получаем логгер loguru

# Импортируем I18nLoader для доступа к локализованным строкам (если нужно в адаптере)
from core.i18n import I18nLoader

# --- Управление состоянием FSM для поллинговых адаптеров ---
# Используем переданный экземпляр MongoStorage для персистентности.

async def get_fsm_context(storage: MongoStorage, user_id: str):
    """
    Получает или создает FSMContext для данного пользователя в этом адаптере,
    используя переданное хранилище.
    Использует user_id как ключ состояния.
    """
    # Ключ для уникальной идентификации контекста пользователя в хранилище.
    fsm_key = ("instagram", str(user_id)) # Используем user_id как ключ состояния для Instagram

    # Arbitrary IDs for FSMContext
    bot_id = "instagram_adapter" # Произвольный ID адаптера
    chat_id = user_id # Используем user_id как chat_id для контекста

    return FSMContext(storage=storage, key=fsm_key, bot_id=bot_id, chat_id=chat_id)


# --- Логика Адаптера Instagram (поллинг) ---
# !!! Внимание: Использование Instagrapi и поллинга DM является высокорискованным и ненадежным для продакшена.
# !!! Аккаунты могут быть заблокированы. Это MVP реализация.

async def start_instagram(client_id: str, router: Router, storage: MongoStorage, i18n: I18nLoader, username: str, password: str):
    """
    Инициализирует и запускает адаптер Instagram (поллинг direct messages).

    Args:
        client_id: ID клиента.
        router: Экземпляр core.router.Router.
        storage: Экземпляр персистентного хранилища состояний FSM (MongoStorage).
        i18n: Экземпляр I18nLoader для локализации.
        username: Логин Instagram.
        password: Пароль Instagram.
    """
    # Проверяем наличие учетных данных
    if not username or not password:
        # Используем i18n для логирования ошибки
        error_msg = i18n.get("instagram_credentials_missing_error", i18n.default_lang, f"Instagram credentials not set for client {client_id}. Instagram adapter will not start.") # TODO: Добавить ключ в i18n
        logger.error(error_msg)
        return # Пропускаем запуск, если нет учетных данных

    logger.info(f"Попытка запуска адаптера Instagram для клиента {client_id} ({username})...")

    # Используем переданное персистентное хранилище состояний FSM
    # storage = MemoryStorage() # Заменяем на переданный MongoStorage экземпляр

    cl = Client()
    # TODO: Реализовать загрузку/сохранение сессии из БД или файла для персистентности.
    # Это критически важно для продакшена, чтобы избежать частых логинов и проблем с 2FA/челленджами.
    # (Логика SessionManager была в первом скрипте, но удалена как часть "безопасности").
    # Пример загрузки сессии (НУЖНО РЕАЛИЗОВАТЬ):
    # session_data = await load_instagram_session(client_id) # Ваша функция загрузки из БД
    # if session_data:
    #     try:
    #         cl.load_settings(session_data)
    #         logger.info(f"Сессия Instagram загружена для клиента {client_id}.")
    #         # Optional: Verify session validity (e.g., cl.get_timeline_feed())
    #         cl.get_timeline_feed()
    #         logger.info(f"Сессия Instagram для клиента {client_id} валидна.")
    #     except Exception as e:
    #         logger.warning(f"Не удалось загрузить или проверить сессию Instagram для {username}: {e}. Попытка логина.")
    #         # Fallback to login if loading fails


    # --- Процесс логина с обработкой Challenge ---
    # Попытка логина, если сессия не загружена или невалидна
    if not cl.is_logged_in:
        try:
            logger.info(f"Выполняется вход в Instagram для пользователя {username}...")
            cl.login(username, password)
            logger.success(f"Вход в Instagram выполнен успешно для пользователя {username}.")
            # TODO: Сохранить состояние сессии после успешного логина
            # session_data_to_save = cl.get_settings()
            # await save_instagram_session(client_id, session_data_to_save) # Ваша функция сохранения в БД
            # logger.info(f"Сессия Instagram сохранена для клиента {client_id}.")

        except ChallengeRequired as e:
            # Используем i18n для сообщения об ошибке логина
            error_msg = i18n.get("instagram_challenge_required_error", i18n.default_lang, f"Instagram login requires challenge for {username}. Requires manual intervention!") # TODO: Добавить ключ в i18n
            logger.critical(f"{error_msg}: {e}. Детали: {e.challenge_context}")
            # Если требуется челлендж, адаптер не может продолжить работу автоматически.
            # Для MVP: логируем и завершаем функцию (адаптер не запустится).
            # В продакшене: нужно реализовать логику решения челленджа (через API, уведомление админа).
            return # Не можем запустить поллинг без успешного логина/обхода челленджа

        except LoginRequired as e:
            error_msg = i18n.get("instagram_login_required_error", i18n.default_lang, f"Instagram login required for {username}, session is invalid. Need to login again.") # TODO: Добавить ключ в i18n
            logger.critical(f"{error_msg}: {e}.")
            # Это может произойти, если загрузка сессии не удалась или сессия истекла.
            # Для MVP: логируем и завершаем функцию.
            return # Не можем запустить поллинг без успешного логина

        except Exception as e:
            # Логируем другие критические ошибки логина
            error_msg = i18n.get("instagram_login_failed_error", i18n.default_lang, f"Critical Instagram login failed for {username}.") # TODO: Добавить ключ в i18n
            logger.critical(f"{error_msg}: {e}", exc_info=True)
            return # Не можем запустить поллинг

    # Проверяем, что мы залогинены после всех попыток/загрузки сессии
    if not cl.is_logged_in:
         error_msg = i18n.get("instagram_not_logged_in_error", i18n.default_lang, f"Instagram is not logged in for {username} after attempts. Adapter will not start.") # TODO: Добавить ключ в i18n
         logger.error(error_msg)
         return # Если не залогинены, выходим


    # --- Цикл поллинга ---
    # !!! Поллинг Instagram Direct НЕ является надежным методом для продакшена и может привести к блокировке.
    # !!! Используйте с осторожностью.
    # !!! Нет персистентного хранения ID обработанных сообщений в этом MVP.

    polling_interval_seconds = 10 # Интервал проверки новых сообщений (в секундах)
    processed_message_ids = set() # ВНИМАНИЕ: Не персистентное хранилище ID обработанных сообщений! Теряется при перезапуске.
                                   # Для продакшена: использовать Redis, MongoDB или другой персистентный кэш.

    logger.info(f"Запуск цикла поллинга Instagram Direct для клиента {client_id} ({username}) каждые {polling_interval_seconds} секунд...")

    while True: # Цикл выполняется бесконечно, пока задача не будет отменена
        try:
            # 1. Получаем последние треды (диалоги)
            # amount=20 получает 20 самых последних тредов. Для большого количества тредов нужно обрабатывать пагинацию.
            threads = cl.direct_threads(amount=20)

            # 2. Для каждого треда, получаем последние сообщения
            for thread in threads:
                thread_id = str(thread.id) # ID треда/диалога

                # Получаем последние сообщения в треде.
                # amount=50 - получаем до 50 сообщений. Нужно получать только НОВЫЕ сообщения.
                # Без персистентного хранения ID последнего обработанного сообщения на тред,
                # мы можем обрабатывать дубликаты или пропускать сообщения при долгом простое.
                # TODO: Реализовать персистентное хранение последнего обработанного ID/timestamp на тред!

                messages = cl.direct_thread(thread_id=thread_id, amount=50).messages # Получаем последние сообщения

                # Сортируем сообщения по timestamp возрастанию, чтобы обрабатывать их в хрологическом порядке
                messages.sort(key=lambda m: m.timestamp)

                # 3. Обрабатываем каждое сообщение в треде
                for message in messages:
                    message_id = str(message.id) # Уникальный ID сообщения Instagram
                    sender_user_id = str(message.user_id) # ID отправителя сообщения

                    # Проверяем, что сообщение:
                    # а) Не от бота самого себя (сравниваем с cl.user_id - ID нашего залогиненного аккаунта)
                    # б) Еще не было обработано в предыдущих циклах поллинга (проверяем в set processed_message_ids)
                    #    ВНИМАНИЕ: Эта проверка работает только до перезапуска контейнера!

                    if sender_user_id != str(cl.user_id) and message_id not in processed_message_ids:

                        # Определяем user_id для обработки. Для Direct сообщений user_id отправителя подходит.
                        user_id_for_processing = sender_user_id

                        # Извлекаем текст сообщения (обрабатываем разные типы сообщений, создаем заглушки для нетекстовых)
                        # Заглушки [Медиа-файл] и т.п. обрабатываются в ядре (пропускаются для LLM).
                        text = message.text if hasattr(message, 'text') and message.text else ""
                        if not text and hasattr(message, 'item_type'):
                           if message.item_type == "media":
                               text = "[Медиа-файл]"
                           elif message.item_type == "voice_media":
                               text = "[Голосовое сообщение]"
                           elif message.item_type == "link" and hasattr(message, 'link'):
                               text = f"[Ссылка: {message.link.text or message.link.url}]"
                           else:
                               text = f"[Сообщение типа {message.item_type}]"

                        # Пропускаем сообщения без текста или с заглушками (если не хотим их обрабатывать)
                        # TODO: Решить, нужно ли сохранять в историю получение медиа/голоса?
                        if not text or text.strip() == "" or text.startswith("[Сообщение типа"):
                             logger.debug(f"Пропущено пустое, заглушка или нетекстовое сообщение ID {message_id} от {sender_user_id} в треде {thread_id} ({client_id}). Текст: '{text[:50]}'")
                             # Добавляем ID в обработанные (не персистентно)
                             processed_message_ids.add(message_id)
                             continue # Пропускаем дальнейшую обработку


                        logger.info(f"Instagram message от {sender_user_id} в треде {thread_id} ({client_id}): {text[:70]}{'...' if len(text)>70 else ''}")

                        # --- Получаем FSM Context для треда ---
                        # Используем thread_id как ключ состояния FSM.
                        state = await get_fsm_context(storage, thread_id) # Используем thread_id как ключ состояния

                        # --- Обрабатываем Сообщение ---
                        # Вызываем основной метод роутера для обработки сообщения.
                        # Передаем client_id, ID пользователя (отправителя), текст, платформу, FSM state, ID треда.
                        # Роутер сам решит, FSM это ввод или новый запрос для LLM.
                        # Роутер вернет текст ответа, который нужно отправить пользователю.

                        # TODO: Определить язык пользователя/сообщения для системных сообщений.
                        # Instagram API не предоставляет language_code пользователя в direct messages.
                        # LLM в CoreProcessor определит язык входящего сообщения.
                        # Для системных сообщений FSM, Роутер использует язык из state или дефолтный.
                        # Здесь мы не передаем определенный язык явно в process_inbound_message.

                        response_text = await router.process_inbound_message(
                            client_id=client_id,
                            user_id=user_id_for_processing, # ID отправителя сообщения
                            text=text,
                            platform="instagram", # Указываем платформу
                            state=state, # Передаем объект состояния FSM
                            thread_id=thread_id, # Передаем ID треда/диалога
                            # Передаем некоторые оригинальные данные сообщения для отладки в ядре
                            message_data={"message_id": message_id, "thread_id": thread_id, "sender_user_id": sender_user_id, "timestamp": str(message.timestamp), "item_type": message.item_type},
                             # Язык не передаем явно.
                        )

                        # Отправляем текст ответа, полученный от роутера, обратно в тред Instagram
                        if response_text:
                            # Используем asyncio.create_task, чтобы не блокировать цикл поллинга на время отправки.
                            logger.info(f"Отправка ответа в тред {thread_id} ({client_id}): {response_text[:70]}{'...' if len(response_text)>70 else ''}")
                            asyncio.create_task(cl.direct_send(response_text, [thread_id])) # Отправляем ответ в тред
                        else:
                            logger.warning(f"Роутер вернул пустой ответ для треда {thread_id} клиента {client_id}.")

                        # После успешной обработки, добавляем ID сообщения в set обработанных (не персистентно)
                        processed_message_ids.add(message_id)
                        # TODO: Сохранять в персистентное хранилище!
                        # TODO: Реализовать очистку старых ID из set/хранилища, чтобы избежать утечки памяти/переполнения.

                # TODO: После обработки сообщений в треде, можно отметить их как прочитанные?
                # cl.direct_send_seen(thread_id) # Использование этой функции может влиять на поллинг

            # --- Интервал поллинга ---
            await asyncio.sleep(polling_interval_seconds)

        except ClientError as e:
            # Обработка специфических ошибок Instagrapi (rate limits, челленджи, логин требуется)
            # Используем i18n для логирования ошибок, если загрузчик доступен
            error_key = "instagram_client_error" # TODO: Добавить ключ в i18n
            if isinstance(e, ChallengeRequired):
                 error_key = "instagram_challenge_required_error"
            elif isinstance(e, LoginRequired):
                 error_key = "instagram_login_required_error"

            error_msg = i18n.get(error_key, i18n.default_lang, f"Instagram client error for {username}. Stopping polling.")
            logger.error(f"{error_msg}: {e}", exc_info=True)

            if isinstance(e, ChallengeRequired) or isinstance(e, LoginRequired):
                 # Если требуется челлендж или логин, адаптер не может продолжить.
                 # Для MVP: завершаем функцию.
                 # В продакшене: нужно реализовать логику обхода или уведомления админа.
                 # Очищаем set обработанных ID (они потеряются), в продакшене нужно сохранить в персистентное хранилище.
                 processed_message_ids.clear()
                 break # Выходим из цикла поллинга
            # Для других клиентских ошибок (например, лимиты запросов), ждем дольше перед следующей попыткой поллинга
            await asyncio.sleep(60)
        except Exception as e:
            # Логируем любые другие непредвиденные ошибки
            error_msg = i18n.get("instagram_unexpected_error", i18n.default_lang, "Unexpected error in Instagram adapter.") # TODO: Добавить ключ в i18n
            logger.error(f"{error_msg} для клиента {client_id}: {e}", exc_info=True)
            # Ждем дольше при непредвиденных ошибках
            await asyncio.sleep(30)

    logger.warning(f"Адаптер Instagram остановлен для клиента {client_id} ({username}).")


# Пример запуска адаптера (вызывается из main.py)
# if __name__ == "__main__":
#     # При автономном запуске необходимо настроить логирование, создать Router, Storage, I18nLoader
#     # и передать их сюда, а также получить учетные данные из окружения или конфига.
#     # Например:
#     # asyncio.run(async_main_for_standalone_adapter_test()) # Нужна обертка для async

EOF

log "SUCCESS" "ui/instagram/main.py создан/обновлен."


log "INFO" "Наполнение файла ui/tiktok/main.py..."
# ui/tiktok/main.py (from second script, updated imports/calls, state management, i18n)
cat << 'EOF' > "$PROJECT_DIR/ui/tiktok/main.py"
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import asyncio
import logging # Используем loguru
import httpx # Для взаимодействия с ManyChat API
# from core.router import process_inbound_message # Импортируем Router класс
from aiogram.fsm.context import FSMContext # Для управления состоянием FSM
# from aiogram.fsm.storage.memory import MemoryStorage # Заменяем на MongoStorage
# from aiogram.fsm.storage.base import BaseStorage # Для указания типа хранилища
from motor_fsm_storage.storage import MongoStorage # Импортируем MongoStorage из нужной библиотеки
import uuid # Для симуляции ID взаимодействия (удалить при реальной интеграции)
import random # Для симуляции (удалить при реальной интеграции)


# Импортируем Router класс для type hinting
from core.router import Router

# Предполагаем, что loguru настроен в core.config или main.py
logger = logging.getLogger(__name__) # Получаем логгер loguru

# Импортируем I18nLoader для доступа к локализованным строкам (если нужно в адаптере)
from core.i18n import I18nLoader

# --- Управление состоянием FSM для поллинговых адаптеров ---
# Используем переданный экземпляр MongoStorage для персистентности.

async def get_fsm_context(storage: MongoStorage, user_id: str):
    """
    Получает или создает FSMContext для данного пользователя в этом адаптере,
    используя переданное хранилище.
    Использует user_id как ключ состояния.
    """
    # Ключ для уникальной идентификации контекста пользователя в хранилище.
    fsm_key = ("tiktok", str(user_id)) # Используем user_id как ключ состояния для TikTok

    # Arbitrary IDs for FSMContext
    bot_id = "tiktok_adapter" # Произвольный ID адаптера
    chat_id = user_id # Используем user_id как chat_id для контекста

    return FSMContext(storage=storage, key=fsm_key, bot_id=bot_id, chat_id=chat_id)


# --- Логика Адаптера TikTok (предполагается через ManyChat) ---
# !!! Внимание: Реальная интеграция с TikTok DM через сторонние сервисы или неофициальные методы
# !!! может быть нестабильной, высокорискованной и нарушать условия использования TikTok/сервисов.
# !!! Этот код основан на ПРЕДПОЛОЖЕНИЯХ о работе ManyChat API для TikTok и может потребовать полной переработки.

async def send_message_manychat(subscriber_id: str, message: str, manychat_api_token: str):
    """
    Отправляет сообщение через ManyChat API (предполагая, что ManyChat подключен к TikTok).

    Args:
        subscriber_id: ID подписчика ManyChat (связанный с пользователем TikTok).
        message: Текст сообщения.
        manychat_api_token: API токен ManyChat.
    """
    if not manychat_api_token:
        logger.error("ManyChat API Token не установлен. Невозможно отправить сообщение.")
        return # Не можем отправить сообщение

    # !!! ПРЕДУПРЕЖДЕНИЕ: Этот URL API ManyChat (fb/sending/sendContent) выглядит как Facebook endpoint.
    # !!! Найдите актуальную документацию ManyChat API для отправки сообщений TikTok подписчикам.
    # !!! Endpoint и структура payload могут сильно отличаться.
    send_url = "https://api.manychat.com/fb/sending/sendContent" # <--- СКОРЕЕ ВСЕГО НЕВЕРНЫЙ URL ДЛЯ TIKTOK

    headers = {"Authorization": f"Bearer {manychat_api_token}"}
    # Структура payload может отличаться для TikTok
    payload = {
        "subscriber_id": subscriber_id,
        "message": message # Или более структурированный объект сообщения, специфичный для ManyChat/TikTok
    }

    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(send_url, json=payload, headers=headers)
            response.raise_for_status() # Выбросит HTTPStatusError для плохих ответов
            logger.success(f"Сообщение отправлено через ManyChat API подписчику {subscriber_id}. Статус: {response.status_code}")
            # logger.debug(f"Ответ ManyChat API: {response.json()}") # Логирование ответа
            return response.json() # Возвращаем ответ ManyChat API
    except httpx.HTTPStatusError as e:
        logger.error(f"HTTP ошибка ManyChat API при отправке сообщения подписчику {subscriber_id}: {e.response.status_code} - {e.response.text[:200]}", exc_info=True)
        raise # Пробрасываем исключение.
    except Exception as e:
        logger.error(f"Ошибка ManyChat API при отправке сообщения подписчику {subscriber_id}: {e}", exc_info=True)
        raise # Пробрасываем исключение.


async def start_tiktok(client_id: str, router: Router, storage: MongoStorage, i18n: I18nLoader, manychat_api_token: str):
    """
    Инициализирует и запускает адаптер TikTok (через ManyChat).
    Этот код предполагает, что ManyChat интегрирован с TikTok и предоставляет способ
    получения входящих сообщений (например, Webhook или Polling API).
    Оригинальный пример скрипта использовал ПОЛЛИНГ (`client.get`).
    WEBHOOK от ManyChat на ваш FastAPI сервер был бы более эффективным.

    Args:
        client_id: ID клиента.
        router: Экземпляр core.router.Router.
        storage: Экземпляр персистентного хранилища состояний FSM (MongoStorage).
        i18n: Экземпляр I18nLoader для локализации.
        manychat_api_token: API токен ManyChat.
    """
    # Проверяем наличие токена ManyChat
    if not manychat_api_token:
        # Используем i18n для логирования ошибки
        error_msg = i18n.get("manychat_token_missing_error", i18n.default_lang, f"ManyChat API Token not set for client {client_id}. TikTok adapter will not start.") # TODO: Добавить ключ в i18n
        logger.error(error_msg)
        return # Пропускаем запуск, если нет токена

    logger.info(f"Попытка запуска адаптера TikTok (ManyChat) для клиента {client_id}...")

    # Используем переданное персистентное хранилище состояний FSM
    # storage = MemoryStorage() # Заменяем на переданный MongoStorage экземпляр

    # --- Цикл поллинга (основан на примере из оригинального скрипта) ---
    # !!! ПРИМЕЧАНИЕ: Поллинговый подход в оригинальном скрипте (client.get(f"https://api.manychat.com/tiktok/interactions?client_id={client_id}"))
    # !!! СКОРЕЕ ВСЕГО НЕ ЯВЛЯЕТСЯ НАСТОЯЩИМ API ManyChat. Это, вероятно, был placeholder.
    # !!! Вам нужно обратиться к документации ManyChat API для правильного способа получения входящих сообщений от подписчиков TikTok.
    # !!! Механизм Webhook от ManyChat, указывающий на ваш FastAPI, является наиболее вероятным рабочим подходом.
    # Код ниже реализует логику поллинга *как она была написана*, но рассматривайте ее как placeholder.

    polling_interval_seconds = 60 # Интервал поллинга ManyChat (пример, возможно, нужно настроить)
    processed_interaction_ids = set() # ВНИМАНИЕ: Не персистентное хранилище ID обработанных сообщений! Теряется при перезапуске.
                                   # Для продакшена: использовать Redis, MongoDB или другой персистентный кэш.


    async with httpx.AsyncClient(timeout=30.0) as client: # Используем httpx для поллинга API
        logger.info(f"Запуск цикла поллинга ManyChat (TikTok) для клиента {client_id} каждые {polling_interval_seconds} секунд...")
        while True: # Цикл выполняется бесконечно, пока задача не будет отменена
            try:
                # --- PLACEHOLDER ManyChat Polling API Call ---
                logger.debug(f"Поллинг ManyChat для TikTok взаимодействий для клиента {client_id}...")
                # !!! ЗАМЕНИТЕ ЭТОТ КОД НА РЕАЛЬНЫЙ ВЫЗОВ ManyChat API для получения входящих сообщений/взаимодействий !!!
                # Например:
                # response = await client.get(f"https://api.manychat.com/tiktok/getIncomingMessages?token={manychat_api_token}&client_id={client_id}")
                # Или используйте официальный SDK ManyChat, если доступен.

                # --- СИМУЛЯЦИЯ получения сообщений (УДАЛИТЬ ПРИ РЕАЛЬНОЙ ИНТЕГРАЦИИ) ---
                # Это просто симуляция структуры ответа из оригинального скрипта.
                interactions = [] # В реальном сценарии, это будет результат API вызова
                # # Пример симуляции входящего сообщения каждые ~3 минуты
                # if random.random() < (polling_interval_seconds / 180):
                #      simulated_user_id = "tiktok_user_" + str(random.randint(1000, 9999))
                #      interactions.append({"user_id": simulated_user_id, "text": "Привет! Что посоветуете для путешествия?", "interaction_id": str(uuid.uuid4())})
                #      if random.random() < 0.5: # Симулируем второе сообщение от другого пользователя
                #          interactions.append({"user_id": "tiktok_user_" + str(random.randint(1000, 9999)), "text": "Цены на туры в Дубай?", "interaction_id": str(uuid.uuid4())})
                # import random, uuid # Нужны импорты для симуляции


                for interaction in interactions:
                    # Парсим входящие данные взаимодействия
                    user_id = str(interaction.get("user_id")) # ID пользователя ManyChat / TikTok
                    text = interaction.get("text", "") # Текст сообщения
                    interaction_id = interaction.get("interaction_id") # Уникальный ID взаимодействия (сообщения/комментария)

                    # Проверяем, что есть user_id и текст, и что взаимодействие еще не обработано
                    if not user_id or not text or not text.strip() or interaction_id in processed_interaction_ids:
                        if interaction_id in processed_interaction_ids:
                            logger.debug(f"Пропущено: Взаимодействие ID {interaction_id} уже обработано для клиента {client_id}.")
                        else:
                             logger.debug(f"Пропущено: Взаимодействие без user ID или текста для клиента {client_id}: {interaction}")
                        continue # Пропускаем невалидные или уже обработанные взаимодействия


                    logger.info(f"TikTok (через ManyChat) message от {user_id} ({client_id}): {text[:70]}{'...' if len(text)>70 else ''}")

                    # --- Получаем FSM Context для пользователя ---
                    # Используем user_id как ключ состояния FSM
                    state = await get_fsm_context(storage, user_id) # Используем user_id как ключ состояния

                    # --- Обрабатываем Сообщение ---
                    # Вызываем основной метод роутера для обработки сообщения.
                    # Роутер сам определит, находится ли пользователь в FSM или это новый запрос для LLM.
                    # Роутер вернет текст ответа, который нужно отправить пользователю.

                    # TODO: Определить язык пользователя/сообщения для системных сообщений.
                    # ManyChat API может предоставлять язык пользователя. Если нет, определить по тексту или использовать дефолтный.
                    # LLM в CoreProcessor определит язык входящего сообщения.
                    # Для системных сообщений FSM, Роутер использует язык из state или дефолтный.
                    # Здесь мы не передаем определенный язык явно в process_inbound_message.

                    response_text = await router.process_inbound_message(
                        client_id=client_id,
                        user_id=user_id, # ID пользователя
                        text=text,
                        platform="tiktok", # Указываем платформу
                        state=state, # Передаем объект состояния FSM
                        thread_id=user_id, # Для простоты, используем user_id как thread_id
                        message_data={"interaction_id": interaction_id, "user_id": user_id, "text": text}, # Передаем оригинальные данные для отладки
                         # Язык не передаем явно.
                    )

                    # Отправляем текст ответа, полученный от роутера, обратно пользователю через ManyChat API
                    if response_text:
                        # Используем asyncio.create_task, чтобы не блокировать цикл поллинга на время отправки.
                        logger.info(f"Отправка ответа пользователю {user_id} ({client_id}) через ManyChat: {response_text[:70]}{'...' if len(response_text)>70 else ''}")
                        # Вызываем метод отправки через ManyChat API
                        asyncio.create_task(send_message_manychat(user_id, response_text, manychat_api_token))
                    else:
                         logger.warning(f"Роутер вернул пустой ответ для пользователя {user_id} клиента {client_id}.")

                    # После успешной обработки, добавляем ID взаимодействия в set обработанных (не персистентно)
                    processed_interaction_ids.add(interaction_id)
                    # TODO: Сохранять в персистентное хранилище!
                    # TODO: Реализовать очистку старых ID из set/хранилища, чтобы избежать утечки памяти/переполнения.


                # --- Интервал поллинга ---
                await asyncio.sleep(polling_interval_seconds)

            except Exception as e:
                # Логируем любые ошибки в адаптере
                # Используем i18n для логирования ошибок, если загрузчик доступен
                error_msg = i18n.get("tiktok_adapter_error", i18n.default_lang, "Error in TikTok/ManyChat adapter.") # TODO: Добавить ключ в i18n
                logger.error(f"{error_msg} для клиента {client_id}: {e}", exc_info=True)
                # Ждем дольше при ошибках
                await asyncio.sleep(30)

    logger.warning(f"Адаптер TikTok (ManyChat) остановлен для клиента {client_id}.")


# Пример запуска адаптера (вызывается из main.py)
# if __name__ == "__main__":
#     # При автономном запуске необходимо настроить логирование, создать Router, Storage, I18nLoader
#     # и передать их сюда, а также получить токен ManyChat из окружения или конфига.
#     # Например:
#     # asyncio.run(async_main_for_standalone_adapter_test()) # Нужна обертка для async

EOF

log "SUCCESS" "ui/tiktok/main.py создан/обновлен."


log "INFO" "Наполнение файла dev_gui/editor.py (с аутентификацией)..."
# dev_gui/editor.py (with Basic Authentication using Flask-HTTPAuth)
cat << 'EOF' > "$PROJECT_DIR/dev_gui/editor.py"
from flask import Flask, request, render_template_string, redirect, url_for, jsonify, flash, get_flashed_messages
import yaml # Для парсинга и проверки YAML
import os # Для работы с путями файлов
import logging # Используем loguru вместо стандартного logging
# Импортируем настройки для получения учетных данных редактора и секретного ключа Flask
from core.config import setup_logging, EDITOR_USER, EDITOR_PASSWORD, FLASK_SECRET_KEY
# Импортируем Flask-HTTPAuth для базовой аутентификации
from flask_httpauth import HTTPBasicAuth


# Настройка логирования для Flask app, если не вызвано в main или глобально
# setup_logging() # Обычно вызывается в main.py
# Получаем логгер Loguru. Имя логгера '__name__' соответствует имени модуля.
logger = logging.getLogger(__name__)

# Создаем экземпляр Flask приложения
app = Flask(__name__)
# Устанавливаем секретный ключ из конфига/окружения.
# Он используется Flask для защиты сессий (например, flash сообщений).
app.config['SECRET_KEY'] = FLASK_SECRET_KEY

# Инициализация базовой HTTP аутентификации
auth = HTTPBasicAuth()

# Функция, которая верифицирует пользователя и пароль
# Вызывается Flask-HTTPAuth при попытке доступа к защищенному маршруту.
@auth.verify_password
def verify_password(username, password):
    """Проверяет логин и пароль для базовой аутентификации."""
    # Получаем учетные данные редактора из конфига/переменных окружения
    if username == EDITOR_USER and password == EDITOR_PASSWORD:
        logger.info(f"Успешная попытка аутентификации в Dev GUI для пользователя '{username}'")
        return username # При успешной аутентификации возвращаем имя пользователя
    logger.warning(f"Неудачная попытка аутентификации в Dev GUI для пользователя '{username}'. IP: {request.remote_addr}") # Логируем IP для безопасности
    return None # При неудаче возвращаем None

# Маршрут для редактора YAML конфигов
# Доступ к этому маршруту требует успешной базовой аутентификации (@auth.login_required)
@app.route("/editor", methods=["GET", "POST"])
@auth.login_required # Защищаем маршрут с помощью базовой аутентификации
def editor():
    """Редактор YAML файлов конфигурации клиента."""
    # Получаем имя клиента из параметров запроса URL (например, /editor?client=tourism)
    # По умолчанию равно None, если не указано.
    client_id = request.args.get('client', None)
    
    # Получаем список доступных клиентов из файлов в ./configs/ для навигации
    available_clients = [f.replace('.yaml', '') for f in os.listdir("configs") if f.endswith('.yaml')]
    available_clients.sort() # Сортируем для консистентности

    if not client_id:
        # Если client_id не указан в URL, показываем список доступных конфигов
        return render_template_string("""
            <!doctype html>
            <title>Config Editor - Select Client</title>
             <style>
                body { font-family: sans-serif; line-height: 1.5; margin: 20px; }
                h1 { border-bottom: 1px solid #eee; padding-bottom: 10px; }
                ul { list-style: none; padding: 0; }
                li { margin-bottom: 8px; }
                a { text-decoration: none; color: #007bff; }
                a:hover { text-decoration: underline; }
            </style>
            <h1>Config Editor</h1>
            <p>Пожалуйста, выберите клиента для редактирования конфига (из файлов в <code>./configs/</code>):</p>
            <ul>
            {% for cf in config_files %}
                <li><a href="{{ url_for('editor', client=cf) }}">{{ cf }}.yaml</a></li>
            {% endfor %}
            </ul>
            <p><small>Убедитесь, что соответствующий клиент добавлен в MongoDB (через <code>init_mongo.py</code> или <code>manage_clients.py</code>).</small></p>
        """, config_files=available_clients)


    # Формируем полный путь к файлу конфига на основе client_id и директории 'configs'
    config_path = os.path.join("configs", f"{client_id}.yaml")

    if request.method == "POST":
        # Обработка POST запроса (сохранение содержимого текстового поля в файл)
        data = request.form.get("config") # Получаем данные из текстового поля 'config'
        if data is not None: # Проверяем, что данные были получены
            try:
                 # Опционально: Валидируем синтаксис YAML перед сохранением
                 yaml.safe_load(data) # Пытаемся распарсить YAML для проверки
                 
                 # Сохраняем валидные данные в файл
                 with open(config_path, "w", encoding="utf-8") as f:
                     f.write(data)
                 
                 logger.info(f"Конфигурационный файл '{config_path}' успешно обновлен.")
                 # Используем flash-сообщения для уведомления пользователя об успехе
                 flash(f"Конфиг клиента '{client_id}' ({config_path}) успешно обновлен!", 'success')
                 # Перенаправляем на GET запрос, чтобы избежать повторной отправки формы при обновлении страницы
                 return redirect(url_for('editor', client=client_id))

            except yaml.YAMLError as e:
                 # Обработка ошибок парсинга YAML
                 logger.error(f"Ошибка парсинга YAML при сохранении конфига {config_path}: {e}", exc_info=True)
                 # Используем flash-сообщения для уведомления пользователя об ошибке
                 flash(f"Ошибка сохранения конфига: Некорректный YAML синтаксис. {e}", 'error')
                 # Возвращаем форму GET с введенными данными
                 # Но для простоты, в этом примере, просто перенаправляем на GET и сообщение уйдет через flash.
                 # TODO: Чтобы сохранить введенный текст при ошибке, нужно передать его обратно в шаблон.
                 return redirect(url_for('editor', client=client_id)) # Redirect back to GET page

            except Exception as e:
                 # Обработка других ошибок сохранения файла
                 logger.error(f"Ошибка сохранения файла конфига {config_path}: {e}", exc_info=True)
                 flash(f"Ошибка сохранения конфига: {e}", 'error')
                 return redirect(url_for('editor', client=client_id)) # Redirect back to GET page

        # Если POST запрос без данных в поле 'config'
        flash("Данные для сохранения отсутствуют.", 'warning')
        return redirect(url_for('editor', client=client_id))


    # Обработка GET запроса (отображение формы редактирования)
    config_content = "" # Переменная для содержимого файла

    # Читаем содержимое файла, если он существует
    if not os.path.exists(config_path):
         logger.warning(f"Файл конфига для редактирования не найден: {config_path}")
         # Если файл не найден, создаем базовый шаблон с комментариями
         config_content = f"# Файл конфига для клиента '{client_id}' не найден. Создайте его структуру здесь.\n\n"
         config_content += "default_response:\n  en: \"Hello!\"\n  az: \"Salam!\"\n"
         config_content += "\nflows: # Определение FSM форм\n"
         config_content += "  example_form:\n    # Текст первого вопроса формы\n    en: \"Example form started. What is your name?\"\n    az: \"Nümünə forması başladı. Adınız nədir?\"\n"
         config_content += "    steps: # Шаги формы\n      - fields: # Список полей для первого шага\n          - name: \"Name\" # Название поля\n            validation: \"\" # Тип валидации (phone, number, email и т.д.)\n          - name: \"Email\"\n            validation: \"email\"\n    # URL вебхука для отправки данных формы\n    submit_to: \"http://n8n:5678/webhook/example/form\"\n    # Сообщение после завершения формы\n    thanks:\n      en: \"Thank you!\"\n      az: \"Təşəkkür!\""

    else:
        # Если файл найден, читаем его содержимое
        try:
            with open(config_path, "r", encoding="utf-8") as f:
                config_content = f.read()
        except Exception as e:
            logger.error(f"Ошибка чтения файла конфига {config_path}: {e}", exc_info=True)
            # Если чтение не удалось, показываем ошибку и, если возможно, часть содержимого
            config_content = f"# Ошибка чтения файла: {e}\n\n" + config_content


    # HTML шаблон для отображения формы редактирования
    # Включает текстовое поле с содержимым файла и кнопку сохранения.
    # Используем flash-сообщения для отображения уведомлений об успехе/ошибке.
    return render_template_string("""
        <!doctype html>
        <title>AI Agent Config Editor</title>
        <style>
            body { font-family: sans-serif; line-height: 1.5; margin: 20px; }
            h1 { border-bottom: 1px solid #eee; padding-bottom: 10px; }
            textarea { width: 95%; min-height: 600px; font-family: monospace; padding: 10px; border: 1px solid #ccc; box-sizing: border-box;}
            button { padding: 10px 15px; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 1em;}
            button:hover { background-color: #0056b3; }
            .flashes { list-style: none; padding: 0; margin: 20px 0; }
            .flashes li { padding: 10px; margin-bottom: 10px; border-radius: 5px; }
            .success { background-color: #d4edda; color: #155724; border-color: #c3e6cb; }
            .error { background-color: #f8d7da; color: #721c24; border-color: #f5c6cb; }
            .warning { background-color: #fff3cd; color: #856404; border-color: #ffeeba; }
            .config-nav a { margin-right: 15px; text-decoration: none; color: #007bff; }
            .config-nav a:hover { text-decoration: underline; }
            .config-nav { margin-bottom: 20px; padding-bottom:10px; border-bottom: 1px solid #eee;}
        </style>
        
        <h1>AI Agent Config Editor</h1>
        
        <div class="config-nav">
        <strong>Выберите клиента:</strong>
        {% for client_nav_item in available_clients %}
            <a href="{{ url_for('editor', client=client_nav_item) }}">{{ client_nav_item }}.yaml</a>{% if not loop.last %} | {% endif %}
        {% endfor %}
        </div>

        <p>Редактирование файла: <b>configs/{{ client_id }}.yaml</b></p>
        
        {% with messages = get_flashed_messages(with_categories=true) %}
            {% if messages %}
                <ul class="flashes">
                {% for category, message in messages %}
                    <li class="{{ category }}">{{ message }}</li>
                {% endfor %}
                </ul>
            {% endif %}
        {% endwith %}

        <form method="post">
            <textarea name="config">{{ config_content }}</textarea><br><br>
            <button type="submit">Сохранить Конфиг</button>
        </form>

    """, config_content=config_content, client_id=client_id, available_clients=available_clients)

# Добавим простой маршрут для проверки доступности Dev GUI и перенаправления на редактор
@app.route("/")
@auth.login_required # Защищаем и корень
def index():
     return redirect(url_for('editor')) # Перенаправляем с корня сразу на редактор

# Этот блок для запуска Flask приложения напрямую (не используется в Docker main.py)
# if __name__ == "__main__":
#     # При запуске отдельно нужно настроить логирование и получить ключи из окружения
#     setup_logging() # Ensure logging is configured
#     # NOTE: EDITOR_USER/PASSWORD and FLASK_SECRET_KEY must be set in environment
#     # or configured directly here if running standalone.
#     logger.info("Starting Dev GUI Flask app standalone...")
#     # debug=True only for development, use_reloader=False to avoid issues in some environments
#     # В продакшене нужно запускать через ASGI сервер (uvicorn/hypercorn) или отдельный Flask-совместимый сервер.
#     app.run(host="0.0.0.0", port=5000, debug=False, use_reloader=False)
```

log "SUCCESS" "dev_gui/editor.py создан/обновлен."

log "INFO" "Запуск скрипта настройки AI Agent Platform (Merged MVP) - Часть 4: Создание Docker Compose, Dockerfiles, Init Mongo, Manage Clients, Requirements, Tours CSV, README..."

# --- Add Content to Files (Part 4 - Infrastructure) ---

log "INFO" "Наполнение файла docker-compose.yml..."
# docker-compose.yml (from second script, refined for persistence, auth, and multiple clients idea)
cat << 'EOF' > "$PROJECT_DIR/docker-compose.yml"
version: '3.8'

services:
  # Сервис основного приложения AI Agent
  # Этот сервис запускает main.py, который загрузит ОДНОГО клиента на основе CLIENT_ID
  # и запустит его сконфигурированные адаптеры.
  # Обычно вы запускаете один контейнер 'ai_agent' *на клиента*.
  # Если вы хотите один контейнер для ВСЕХ клиентов, архитектура в main.py требует существенных изменений.
  # В этой версии мы сохраняем подход "один контейнер на клиента" из второго скрипта.
  # Чтобы запустить несколько клиентов, скопируйте эту секцию, измените имя сервиса (например, ai_agent_tourism),
  # container_name, алиас сети и убедитесь, что порты не конфликтуют.
  ai_agent:
    # Используем фундаментальный Dockerfile
    build:
      context: .
      dockerfile: Dockerfile.fundament
    # Порты, которые должны быть доступны извне контейнера.
    # Только порты INBOUND вебхуков должны быть проброшены наружу (например, слушатель вебхуков WhatsApp Evolution).
    # Поллеры (Telegram, Instagram, TikTok) не требуют проброшенных портов.
    # API основного приложения (если добавите /health, /metrics) тоже может потребовать проброса.
    # Адаптер WhatsApp в ui/whatsapp_evolution/main.py запускает СВОЙ aiohttp сервер на внутреннем порту (по умолчанию 8080).
    # Этот порт нужно пробросить, если Evolution API находится ВНЕ Docker сети или обращается по внешнему адресу.
    # Если Evolution API в той же сети Docker, он обращается по внутреннему адресу ai_agent:порт.
    # Dev GUI (если запускается внутри этого контейнера) также может потребовать проброса порта (по умолчанию 5000).
    ports:
      # Пробрасываем порт слушателя вебхуков WhatsApp адаптера (по умолчанию 8080)
      # Этот порт должен быть доступен из контейнера 'evolution_api' (или его внешнего аналога).
      # Если 'evolution_api' в той же сети, используйте имя сервиса и внутренний порт.
      # Если 'ai_agent' также доступен извне (например, через реверс-прокси), этот URL должен быть внешним.
      # Предполагаем, что 'evolution_api' в той же сети и вызывает 'ai_agent' по service name + порт.
      # Если вы запускаете несколько ai_agent контейнеров, КАЖДЫЙ должен иметь свой маппинг порта
      # на УНИКАЛЬНЫЙ внешний порт, если Evolution API внешний.
      - "8080:8080" # Маппинг внешний_порт:внутренний_порт для WhatsApp webhook listener

      # Пробрасываем порт Dev GUI (по умолчанию 5000), если он запускается в этом же контейнере.
      # Если Dev GUI запускается как отдельный сервис, закомментируйте это.
      # Если вы запускаете несколько ai_agent контейнеров, каждый должен иметь свой маппинг порта
      # на УНИКАЛЬНЫЙ внешний порт.
      - "5000:5000" # Маппинг внешний_порт:внутренний_порт для Dev GUI


    environment:
      # --- Переменные окружения для КОНКРЕТНОГО КЛИЕНТА и его мессенджеров ---
      # CLIENT_ID указывает, какого клиента загружать из БД для этого контейнера
      # Установите это в файле .env перед запуском docker-compose!
      - CLIENT_ID=${CLIENT_ID}

      # Передаем секреты мессенджеров для этого клиента.
      # Эти переменные будут прочитаны в main.py и переданы в соответствующий адаптер.
      # Они переопределят значения, которые МОГЛИ БЫ быть в структуре messengers в init_mongo.py.
      # Хранить здесь чувствительные данные ${...} в .env - РИСК БЕЗОПАСНОСТИ для продакшена.
      # Используйте более безопасные методы управления секретами (Docker Secrets, HashiCorp Vault, облачные key vaults).
      # Установите только те переменные для мессенджеров, которые нужны для клиента с данным CLIENT_ID.
      - TELEGRAM_TOKEN=${TELEGRAM_TOKEN}
      - WHATSAPP_API_KEY=${WHATSAPP_API_KEY} # API ключ для Evolution API
      - INSTAGRAM_USERNAME=${INSTAGRAM_USERNAME}
      - INSTAGRAM_PASSWORD=${INSTAGRAM_PASSWORD} # Крайне рискованно!
      - MANYCHAT_API_TOKEN=${MANYCHAT_API_TOKEN}

      # --- Переменные окружения для Core / LLM / N8N ---
      # Установите это в файле .env перед запуском docker-compose!
      - OPENROUTER_API_KEY=${OPENROUTER_API_KEY} # КРИТИЧНО! API ключ для LLM.
      - DEFAULT_LLM_MODEL=${DEFAULT_LLM_MODEL:-deepseek/deepseek-chat} # Модель LLM по умолчанию. Можно переопределить в конфиге клиента в БД.
      - N8N_URL=http://n8n:5678 # URL сервиса N8N внутри Docker сети
      # Учетные данные для Basic Auth n8n, используются CoreProcessor для отправки вебхуков
      - N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER:-admin}
      # !!! Смените пароль по умолчанию в .env И здесь !!!
      - N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD:-secure-n8n-password}

      # --- Настройки MongoDB ---
      # Строка подключения к MongoDB внутри Docker сети (используем service alias)
      - MONGO_URI=mongodb://mongodb:27017/ai_agent
      - MONGO_DB_NAME=${MONGO_DB_NAME:-ai_agent} # Название БД

      # --- Настройки повторных попыток (Tenacity) ---
      - TENACITY_STOP_AFTER_ATTEMPTS=${TENACITY_STOP_AFTER_ATTEMPTS:-5}
      - TENACITY_WAIT_FIXED_SECONDS=${TENACITY_WAIT_FIXED_SECONDS:-3}

      # --- Настройки Логирования (Loguru) ---
      - LOG_LEVEL=${LOG_LEVEL:-INFO} # Уровень логирования

      # --- Настройки Мультиязычности (i18n) ---
      - I18N_PATH=${I18N_PATH:-i18n} # Путь к файлам локализации (внутри контейнера /app/i18n)
      - DEFAULT_LANG=${DEFAULT_LANG:-en} # Язык по умолчанию для системных сообщений

      # --- Настройки Dev GUI ---
      # !!! Смените секретный ключ по умолчанию в .env И здесь !!!
      - FLASK_SECRET_KEY=${FLASK_SECRET_KEY:-super-secret-key-default} # Секретный ключ Flask для Dev GUI
      # !!! Смените пароль по умолчанию в .env И здесь !!!
      - EDITOR_USER=${EDITOR_USER:-admin} # Пользователь для аутентификации Dev GUI
      - EDITOR_PASSWORD=${EDITOR_PASSWORD:-admin123} # Пароль для аутентификации Dev GUI

      # --- Специфичные настройки адаптеров ---
      # Для WhatsApp Evolution: URL, по которому ВЕБХУК ЭТОГО контейнера доступен для Evolution API.
      # Если evolution_api в той же сети, это http://[service_alias]:[internal_port_whatsapp]
      # internal_port_whatsapp = 8080 (порт, на котором слушает aiohttp в ui/whatsapp_evolution/main.py)
      # service_alias для этого контейнера = ai_agent (если вы его так назвали)
      # Установите это в файле .env перед запуском docker-compose!
      - WHATSAPP_WEBHOOK_BASE_URL=${WHATSAPP_WEBHOOK_BASE_URL}

    # Зависимости: ai_agent должен ждать старта БД и n8n (и evolution_api, если нужен WhatsApp)
    depends_on:
      - mongodb
      - n8n
      # Зависит от evolution_api только если вы запускаете адаптер whatsapp_evolution.
      # Запуск сервиса только при включенном адаптере сложен в docker-compose.
      # Предполагаем, что зависимость всегда указана, если потенциально может понадобиться.
      - evolution_api

    restart: unless-stopped # Перезапускать, если он остановился, кроме ручной остановки
    networks:
      app-network: # Присоединяемся к пользовательской сети
        # Уникальный псевдоним в сети Docker для этого контейнера.
        # Нужен, если evolution_api или другие сервисы обращаются к нему по имени + порту вебхука.
        # Если вы запускаете несколько контейнеров ai_agent (по клиентам), КАЖДЫЙ должен иметь УНИКАЛЬНЫЙ псевдоним.
        # Например: ai_agent_green_travel, ai_agent_tourism. И WHATSAPP_WEBHOOK_BASE_URL должен указывать на правильный псевдоним.
        # В текущем варианте, где service name = ai_agent, псевдоним может совпадать с service name.
        aliases:
          - ai_agent # Псевдоним для внутреннего сетевого взаимодействия (используется WHATSAPP_WEBHOOK_BASE_URL)

  # Сервис базы данных MongoDB
  mongodb:
    image: mongo:6 # Используем Mongo 6
    container_name: ${PROJECT_NAME}_mongodb # Имя контейнера с префиксом проекта
    # Порт 27017 по умолчанию не пробрасывается наружу для безопасности.
    # ports:
    #   - "27017:27017" # Пробрасывайте только если нужен прямой внешний доступ (не рекомендуется)
    volumes:
      - mongo_data:/data/db # Персистентное хранилище для данных MongoDB
    # Настройки пользователя и пароля для инициализации (используются init_mongo и n8n)
    environment:
      MONGO_INITDB_ROOT_USERNAME=${MONGO_INITDB_ROOT_USERNAME:-admin}
      # !!! Смените пароль по умолчанию в .env И здесь !!!
      MONGO_INITDB_ROOT_PASSWORD=${MONGO_INITDB_ROOT_PASSWORD:-admin_password}
    restart: unless-stopped
    networks:
      app-network:
        aliases:
          - mongodb # Псевдоним для внутреннего сетевого взаимодействия

  # Сервис автоматизации n8n
  n8n:
    image: n8nio/n8n # Последняя версия n8n
    container_name: ${PROJECT_NAME}_n8n
    ports:
      - "5678:5678" # Пробрасываем порт UI n8n наружу

    environment:
      # Настройки Basic Auth n8n
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER:-admin}
      # !!! Смените пароль по умолчанию в .env И здесь !!!
      - N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD:-secure-n8n-password}
      # N8N требуется собственная конфигурация БД, используем MongoDB
      - DB_TYPE=mongodb
      - DB_REPLICA_SET= # Пусто, если не используем реплика-сет
      - DB_DATABASE=${MONGO_DB_NAME:-ai_agent} # Название БД
      # Строка подключения к MongoDB (используем alias и учетные данные root)
      - DB_HOST=mongodb
      - DB_PORT=27017
      - DB_USER=${MONGO_INITDB_ROOT_USERNAME:-admin} # Root пользователь для initial connection N8N? Или создать dedicated n8n user?
      - DB_PASSWORD=${MONGO_INITDB_ROOT_PASSWORD:-admin_password} # Root пароль?

      - N8N_PROTOCOL=http # Использовать http внутри сети
      - N8N_HOST=n8n # Внутреннее имя хоста
      - N8N_PORT=5678 # Внутренний порт
      # WEBHOOK_URL - это URL, который n8n использует для генерации СВОИХ вебхуков (которые вызывает ai_agent).
      # Этот URL должен быть доступен внутренним сервисам (ai_agent).
      - WEBHOOK_URL=http://n8n:5678/ # Указывает на n8n внутри сети

      - NODE_ENV=production
    volumes:
      - n8n_data:/home/node/.n8n # Персистентное хранилище для рабочих процессов n8n и данных
    depends_on:
      - mongodb # N8N использует MongoDB
    restart: unless-stopped
    networks:
      app-network:
        aliases:
          - n8n # Псевдоним для внутреннего сетевого взаимодействия

  # Сервис WhatsApp Evolution API
  # Предоставляет API для взаимодействия с WhatsApp, используемый сервисом ai_agent.
  evolution_api:
    image: atendai/evolution-api:latest # Используем указанный образ
    container_name: ${PROJECT_NAME}_evolution_api
    # Порт 8080 обычно не пробрасывается наружу, если только вы не обращаетесь к Evolution API напрямую извне Docker.
    # ports:
    #   - "8080:8080"
    environment:
      # Конфигурация Evolution API
      # API_KEY - это ключ для вызова Evolution API ДРУГИМИ сервисами (ai_agent's whatsapp adapter).
      # Установите это в файле .env перед запуском docker-compose!
      - API_KEY=${WHATSAPP_API_KEY}
      # WEBHOOK_URL - это URL, который Evolution API должен вызывать для ВХОДЯЩИХ сообщений.
      # Он должен указывать на вебхук-слушатель в КОНТЕЙНЕРЕ ai_agent.
      # Путь должен соответствовать тому, что настроен в ui/whatsapp_evolution/main.py (/webhook/{client_id}).
      # Используем service name и внутренний порт ai_agent, а также CLIENT_ID.
      # Если вы запускаете несколько ai_agent контейнеров, каждый должен иметь свой URL вебхука
      # здесь, указывающий на свой уникальный service alias + порт.
      # Установите это в файле .env перед запуском docker-compose!
      # Например, если CLIENT_ID=green_travel, то WHATSAPP_WEBHOOK_BASE_URL=http://ai_agent_green_travel:8080,
      # а здесь WEBHOOK_URL=http://ai_agent_green_travel:8080/webhook/green_travel.
      - WEBHOOK_URL=http://ai_agent:8080/webhook/${CLIENT_ID:-green_travel}

      - DB_TYPE=mongodb # Evolution API использует MongoDB для своих данных
      - DB_HOST=mongodb # Имя хоста для MongoDB (используем service alias)
      - DB_PORT=27017
      - DB_NAME=${MONGO_DB_NAME:-ai_agent} # Используем то же название БД
      # Добавьте учетные данные MongoDB, если Evolution API требует их для подключения.
      # - DB_USER=${MONGO_INITDB_ROOT_USERNAME:-admin} # Может потребоваться
      # - DB_PASSWORD=${MONGO_INITDB_ROOT_PASSWORD:-admin_password} # Может потребоваться

    depends_on:
      - mongodb # Evolution API использует MongoDB
      # Нет явной зависимости от ai_agent здесь.
    restart: unless-stopped
    networks:
      app-network:
        aliases:
          - evolution-api # Псевдоним для внутреннего сетевого взаимодействия

  # Сервис инициализации MongoDB
  # Запускает init_mongo.py для добавления базовых данных (клиенты, туры, сервисы)
  # Предполагается, что он запускается один раз при первом docker-compose up
  init_mongo:
    # Используем отдельный Dockerfile для инициализации
    build:
      context: .
      dockerfile: Dockerfile.init_mongo
    # Этот сервис должен запуститься и успешно завершиться
    # Ему нужно соединиться с MongoDB
    depends_on:
      - mongodb
    networks:
      app-network:
        aliases:
          - init_mongo # Псевдоним для внутреннего сетевого взаимодействия
    # НЕ перезапускать этот сервис, если он успешно завершился. При ошибке - перезапустить.
    restart: on-failure
    # Добавьте переменные окружения, необходимые для init_mongo.py, если они есть (сейчас нет переменных из env)
    # Например:
    # environment:
    #   - SOME_SETTING=${SOME_SETTING}


# Определение пользовательской bridge сети
networks:
  app-network:
    driver: bridge # Создаем мостовую сеть

# Определение томов для постоянного хранения данных
volumes:
  mongo_data: # Том для данных MongoDB (для mongodb, ai_agent, init_mongo)
  n8n_data:   # Том для данных n8n
  # Для FSM состояний используется MongoDB (коллекция 'fsm_state' в mongo_data), отдельный том не нужен.
```

log "SUCCESS" "docker-compose.yml создан."


log "INFO" "Наполнение файла Dockerfile.fundament..."
# Dockerfile.fundament (обновлен для копирования всех ui/core/dev_gui файлов)
cat << 'EOF' > "$PROJECT_DIR/Dockerfile.fundament"
FROM python:3.11-slim

# Установка системных пакетов, если требуются.
# Например, для Instagrapi с Selenium может потребоваться Chrome/Chromium и его драйвер.
# Это может значительно увеличить размер образа.
# Если Dev GUI запускается в этом же контейнере, и он основан на Flask/aiohttp,
# то дополнительные системные пакеты скорее всего не нужны для этих библиотек.
# Пример установки для Instagrapi+Selenium (опционально, если будете использовать этот метод)
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     chromium \
#     chromium-driver \
#     && rm -rf /var/lib/apt-instances/*

WORKDIR /app

# Копирование файла зависимостей и их установка
COPY requirements.txt .
# Устанавливаем зависимости из requirements.txt
# --no-cache-dir: не сохранять кэш pip, экономит место в образе
# --break-system-packages: разрешить установку в системные директории (может потребоваться в slim образах)
RUN pip install --no-cache-dir -r requirements.txt --break-system-packages


# Копирование исходного кода приложения
# Убедитесь, что все необходимые директории и файлы скопированы.
COPY core/ core/ # Ядро (router, processor, database, config, i18n)
COPY ui/ ui/     # Адаптеры (telegram, whatsapp, instagram, tiktok)
COPY configs/ configs/ # YAML файлы конфигурации клиента
COPY i18n/ i18n/     # Файлы локализации JSON
COPY dev_gui/ dev_gui/ # Файлы Dev GUI (для запуска редактора)

# Копирование основного файла приложения
COPY main.py .

# Копирование других необходимых файлов (если есть)
# COPY manage_clients.py . # manage_clients может запускаться отдельно
# COPY init_mongo.py . # Скрипт инициализации БД, запускается в отдельном контейнере
# COPY tours.csv . # tours.csv нужен только для init_mongo

# Создание директории для логов
RUN mkdir -p /app/logs

# Установка переменных окружения для Python
ENV PYTHONPATH=/app # Добавляем директорию приложения в PYTHONPATH для корректного импорта
ENV PYTHONUNBUFFERED=1 # Отключаем буферизацию вывода Python

# Команда для запуска основного файла приложения
# main.py будет загружать специфичного клиента на основе переменной окружения CLIENT_ID
# и запускать сконфигурированные для этого клиента адаптеры.
# Если вы запускаете несколько контейнеров ai_agent (по одному на клиента), каждый получит свой CLIENT_ID.
CMD ["python", "main.py"]
EOF

log "SUCCESS" "Dockerfile.fundament создан."


log "INFO" "Наполнение файла Dockerfile.init_mongo..."
# Dockerfile.init_mongo (без изменений)
cat << 'EOF' > "$PROJECT_DIR/Dockerfile.init_mongo"
FROM python:3.11-slim

WORKDIR /app

# Copy requirements and the init script
COPY requirements.txt init_mongo.py ./

# Install dependencies (needs motor, loguru, tenacity from requirements.txt now)
# --break-system-packages: разрешить установку в системные директории (может потребоваться в slim образах)
RUN pip install --no-cache-dir -r requirements.txt --break-system-packages

# Copy tours.csv as init_mongo needs it
COPY tours.csv ./

# Command to run the initialization script
CMD ["python", "init_mongo.py"]
EOF
log "SUCCESS" "Dockerfile.init_mongo создан."


log "INFO" "Наполнение файла init_mongo.py..."
# init_mongo.py (небольшие обновления комментариев и структуры данных клиента)
cat << 'EOF' > "$PROJECT_DIR/init_mongo.py"
import asyncio
import csv
import os # Нужен для проверки наличия файла CSV
import sys # Для вывода ошибок
from motor.motor_asyncio import AsyncIOMotorClient
from datetime import datetime, timezone # Нужен для меток времени
# Импорт конфига не нужен, т.к. здесь прямое подключение по известному адресу

# Замечание: Этот скрипт предназначен для первоначального заполнения *данных* (клиенты, туры, сервисы).
# Инициализация подключения к базе данных, создание индексов и добавление *базовых* данных
# (например, шаблон промпта 'generic', конфигурация маршрутизации n8n по умолчанию)
# должна обрабатываться основным приложением при его запуске (через core.database.init_db),
# поскольку init_mongo запускается только один раз при первом `docker-compose up`.

# Подключение к MongoDB (используем service alias из docker-compose)
MONGO_URI = "mongodb://mongodb:27017/ai_agent" # Жестко задано, должно соответствовать docker-compose и database.py

async def init_mongo_data():
    """
    Инициализирует основные данные, такие как клиенты, туры, сервисы в MongoDB.
    Этот скрипт предполагается к запуску один раз при старте контейнера.
    """
    print(f"[{datetime.now(timezone.utc)}] Запуск инициализации данных MongoDB...")

    client = None # Переменная для клиента MongoDB
    try:
        # Создаем клиент Motor с таймаутом для выбора сервера
        client = AsyncIOMotorClient(MONGO_URI, serverSelectionTimeoutMS=10000) # Увеличенный таймаут

        # Пингуем базу данных для проверки соединения
        await client.admin.command('ping')
        db = client.get_database() # Получаем объект базы данных по имени из MONGO_URI

        print(f"[{datetime.now(timezone.utc)}] Успешное подключение к MongoDB.")

        # --- Добавление/Обновление Клиентов ---
        print(f"[{datetime.now(timezone.utc)}] Инициализация данных клиентов...")
        clients_data = [
            {
                "client_id": "tourism",
                "name": "Tourism Agency",
                "config_file": "tourism.yaml", # Имя файла конфига (в директории ./configs/)
                "business_type": "tourism", # Тип бизнеса (для выбора шаблона промпта)
                "persona": "дружелюбный турагент", # Персона для LLM
                "tone": "дружелюбный", # Тон для LLM
                # Конфигурации мессенджеров теперь загружаются ИЗ ПЕРЕМЕННЫХ ОКРУЖЕНИЯ в main.py
                # и переопределяют значения, которые могли бы быть здесь.
                # Хранить секреты здесь НЕ РЕКОМЕНДУЕТСЯ.
                "messengers": {
                    # Здесь можно указать настройки мессенджеров, не являющиеся секретами (например, активен ли мессенджер)
                    "telegram": {"active": True},
                    "whatsapp": {"active": True, "api_url": "http://evolution-api:8080"}, # URL Evolution API указываем здесь
                    "instagram": {"active": True},
                    "tiktok": {"active": True}
                },
                "created_at": datetime.now(timezone.utc), # Время создания
                "updated_at": datetime.now(timezone.utc) # Время обновления
            },
            {
                "client_id": "beauty_salon",
                "name": "Beauty Salon",
                "config_file": "beauty_salon.yaml",
                 "business_type": "beauty_salon",
                "persona": "вежливый стилист",
                "tone": "формальный",
                "messengers": {
                    "telegram": {"active": True},
                    "whatsapp": {"active": True, "api_url": "http://evolution-api:8080"},
                    "instagram": {"active": True},
                    "tiktok": {"active": True}
                },
                "created_at": datetime.now(timezone.utc),
                "updated_at": datetime.now(timezone.utc)
            },
            {
                "client_id": "green_travel",
                "name": "GreenTravel",
                "config_file": "green_travel.yaml",
                "business_type": "tourism", # Используем 'tourism' тип бизнеса, т.к. для него есть дефолтный промпт.
                "persona": "дружелюбный экологический гид",
                "tone": "дружелюбный",
                 "messengers": {
                    "telegram": {"active": True},
                    "whatsapp": {"active": True, "api_url": "http://evolution-api:8080"},
                    "instagram": {"active": True},
                    "tiktok": {"active": True}
                },
                "created_at": datetime.now(timezone.utc),
                "updated_at": datetime.now(timezone.utc)
            }
        ]
        for client_data in clients_data:
             # Ищем существующий клиент, чтобы сохранить потенциальные пользовательские поля
             existing_client = await db.clients.find_one({"client_id": client_data["client_id"]})
             if existing_client:
                 # Обновляем существующие поля, сохраняем остальные
                 # Note: Это перезапишет существующую секцию messengers полностью, если она есть.
                 # Если нужно мержить, логика будет сложнее.
                 await db.clients.update_one(
                     {"client_id": client_data["client_id"]},
                     {"$set": client_data} # Устанавливаем или обновляем все поля из client_data
                 )
                 print(f"[{datetime.now(timezone.utc)}] Клиент '{client_data['client_id']}' обновлен.")
             else:
                 # Вставляем нового клиента
                 await db.clients.insert_one(client_data)
                 print(f"[{datetime.now(timezone.utc)}] Клиент '{client_data['client_id']}' добавлен.")

        # --- Импорт Туров из CSV (для green_travel примера) ---
        print(f"[{datetime.now(timezone.utc)}] Импорт данных туров...")
        tours_csv_path = "tours.csv" # Путь относительно WORKDIR /app в Dockerfile.init_mongo
        if os.path.exists(tours_csv_path):
            destinations = []
            try:
                with open(tours_csv_path, newline='', encoding='utf-8') as csvfile:
                    reader = csv.DictReader(csvfile)
                    for row in reader:
                         # Проверяем наличие обязательных полей и их тип
                        destination_name = row.get("destination")
                        description = row.get("description")
                        popularity_str = row.get("popularity", "0")
                        price_str = row.get("price", "0.0")

                        if not destination_name or not description:
                             print(f"[{datetime.now(timezone.utc)}] Пропущена строка в CSV из-за отсутствия 'destination' или 'description': {row}")
                             continue

                        try:
                             popularity = int(popularity_str)
                             price = float(price_str)
                        except ValueError:
                             print(f"[{datetime.now(timezone.utc)}] Пропущена строка в CSV из-за некорректного формата 'popularity' или 'price': {row}")
                             continue

                        destinations.append({
                            "client_id": "green_travel", # Связываем туры с клиентом green_travel
                            "name": destination_name,
                            "description": description,
                            "popularity": popularity,
                            "price": price,
                            "created_at": datetime.now(timezone.utc) # Добавляем метку времени
                        })
                
                if destinations:
                    # Удаляем существующие направления для этого клиента перед вставкой новых
                    print(f"[{datetime.now(timezone.utc)}] Удаление существующих направлений для 'green_travel'...")
                    await db.destinations.delete_many({"client_id": "green_travel"})
                    # Вставляем все направления
                    insert_result = await db.destinations.insert_many(destinations)
                    print(f"[{datetime.now(timezone.utc)}] Импортировано {len(insert_result.inserted_ids)} направлений для клиента green_travel из {tours_csv_path}.")
                else:
                     print(f"[{datetime.now(timezone.utc)}] В файле {tours_csv_path} не найдено валидных направлений.")

            except FileNotFoundError:
                print(f"[{datetime.now(timezone.utc)}] Предупреждение: файл {tours_csv_path} не найден. Импорт туров пропущен.")
            except Exception as e:
                print(f"[{datetime.now(timezone.utc)}] Ошибка при импорте туров из {tours_csv_path}: {e}", file=sys.stderr)
                # Выводим traceback для детальной информации об ошибке
                import traceback
                traceback.print_exc(file=sys.stderr)


        # --- Добавление/Обновление Услуг (для beauty_salon примера) ---
        print(f"[{datetime.now(timezone.utc)}] Инициализация данных услуг...")
        services_data = [
            {
                "client_id": "beauty_salon", # Связываем услуги с клиентом beauty_salon
                "name": "Макияж",
                "description": "вечерний макияж для особых случаев",
                "price": 70.0,
                "created_at": datetime.now(timezone.utc)
            },
            {
                "client_id": "beauty_salon",
                "name": "Стрижка",
                "description": "Женская модельная стрижка",
                "price": 50.0,
                "created_at": datetime.now(timezone.utc)
            }
            # TODO: Добавить другие услуги по умолчанию здесь
        ]
        for service_data in services_data:
             # Используем upsert (вставить или обновить) на основе client_id и name услуги
             await db.services.update_one(
                 {"client_id": service_data["client_id"], "name": service_data["name"]},
                 {"$set": service_data}, # Устанавливаем или обновляем все поля из service_data
                 upsert=True # Если документа не существует, вставить его
             )
             print(f"[{datetime.now(timezone.utc)}] Услуга '{service_data['name']}' для клиента {service_data['client_id']} добавлена/обновлена.")


        # --- Общие Настройки Конфигурации (из второго скрипта, коллекция 'config') ---
        # Эта коллекция может хранить настройки, не специфичные для клиента.
        # Секретные ключи и учетные данные перемещены в переменные окружения.
        # Здесь можно сохранить другие глобальные настройки, если они есть.
        # Например, настройки Dev GUI аутентификации МОГЛИ БЫ храниться здесь, но для MVP они в env.

        # Пример: обновить запись с глобальными настройками, если она существует
        # global_settings = { "key": "global_settings", "some_setting": True, "created_at": datetime.now(timezone.utc), "updated_at": datetime.now(timezone.utc) }
        # await db.config.update_one({"key": "global_settings"}, {"$set": global_settings}, upsert=True)
        # print(f"[{datetime.now(timezone.utc)}] Глобальные настройки обновлены.")


        print(f"[{datetime.now(timezone.utc)}] Инициализация данных MongoDB завершена!")

    except Exception as e:
        print(f"[{datetime.now(timezone.utc)}] КРИТИЧЕСКАЯ ОШИБКА во время инициализации данных MongoDB: {e}", file=sys.stderr)
        # Выводим traceback для детальной информации об ошибке
        import traceback
        traceback.print_exc(file=sys.stderr)
        # Пробрасываем исключение дальше, чтобы контейнер Docker завершился с ошибкой.
        raise
    finally:
        # Закрываем соединение с клиентом MongoDB в конце
        if client:
            client.close()
            print(f"[{datetime.now(timezone.utc)}] Соединение с MongoDB закрыто.")

if __name__ == "__main__":
    # Запуск асинхронной функции инициализации данных
    # Note: core.database.init_db (которая создает индексы и базовые данные вроде generic промпта)
    # вызывается в main.py при старте основного приложения.
    # Этот скрипт фокусируется на заполнении начальных *данных* (клиентов, туров, сервисов).
    # Если init_db не была вызвана до запуска этого скрипта, базовые промпты могут отсутствовать,
    # но это не критично для самого init_mongo_data, он добавляет ТОЛЬКО клиентские данные.
    asyncio.run(init_mongo_data())
EOF

log "SUCCESS" "init_mongo.py создан."


log "INFO" "Наполнение файла manage_clients.py..."
# manage_clients.py (небольшие обновления комментариев и структуры данных клиента)
cat << 'EOF' > "$PROJECT_DIR/manage_clients.py"
import asyncio
import sys # Нужен для аргументов командной строки
from motor.motor_asyncio import AsyncIOMotorClient
from datetime import datetime, timezone
import json # Для парсинга JSON из командной строки
import traceback # Для вывода стека ошибок

# Предполагаем, что строка подключения к MongoDB консистентна или берется из окружения (хотя здесь жестко задана)
MONGO_URI = "mongodb://mongodb:27017/ai_agent" # Жестко задано для простоты

async def get_db():
    """Вспомогательная функция для получения соединения с БД для этого скрипта."""
    client = None
    try:
        # Используем таймаут для избежания зависания, если Mongo недоступен
        client = AsyncIOMotorClient(MONGO_URI, serverSelectionTimeoutMS=5000)
        await client.admin.command('ping') # Проверяем соединение
        return client.get_database(), client # Возвращаем объект базы данных и клиента
    except Exception as e:
        print(f"Ошибка подключения к MongoDB: {e}", file=sys.stderr)
        return None, None # Возвращаем None, если подключение не удалось

async def add_or_update_client(client_id, name, config_file, business_type, persona, tone, messengers_config_json):
    """Добавляет или обновляет конфигурацию клиента в MongoDB."""
    db, client_conn = await get_db() # Получаем соединение с БД
    if not db:
        sys.exit(1) # Завершаем работу, если нет соединения с БД

    try:
        # Базовая валидация входных данных
        if not client_id or not name or not config_file or not business_type:
            print("Ошибка: client_id, name, config_file и business_type являются обязательными.", file=sys.stderr)
            return # Выходим, если обязательные поля отсутствуют

        # Парсим JSON строку мессенджеров
        messengers_config = {}
        if messengers_config_json:
             try:
                  messengers_config = json.loads(messengers_config_json)
                  if not isinstance(messengers_config, dict):
                       raise ValueError("Конфигурация мессенджеров должна быть JSON объектом (словарем).")
             except json.JSONDecodeError as e:
                  print(f"Ошибка парсинга JSON для конфигурации мессенджеров: {e}", file=sys.stderr)
                  return
             except ValueError as e:
                  print(f"Неверный формат конфигурации мессенджеров: {e}", file=sys.stderr)
                  return


        client_data = {
            "client_id": client_id,
            "name": name,
            "config_file": config_file, # например, "tourism.yaml" (имя файла в директории ./configs/)
            "business_type": business_type, # например, "tourism", "beauty_salon" (для выбора шаблона промпта LLM)
            "persona": persona, # например, "дружелюбный турагент" (для промпта LLM)
            "tone": tone, # например, "дружелюбный" (для промпта LLM)
            # Конфигурации мессенджеров (включая API ключи) ТЕПЕРЬ БЕРУТСЯ ИЗ ПЕРЕМЕННЫХ ОКРУЖЕНИЯ в main.py
            # и переопределяют значения, которые могли бы быть здесь.
            # Хранить секреты здесь НЕ РЕКОМЕНДУЕТСЯ.
            # Однако, здесь можно сохранить настройки мессенджеров, не являющиеся секретами (например, активен ли мессенджер, API URL)
            # Если messengers_config_json передан, сохраним его.
            "messengers": messengers_config, # Сохраняем переданный JSON как есть

            "updated_at": datetime.now(timezone.utc) # Метка времени последнего обновления
        }

        # Добавляем метку created_at только при первой вставке
        existing_client = await db.clients.find_one({"client_id": client_id})
        if not existing_client:
             client_data["created_at"] = datetime.now(timezone.utc)
             print(f"Клиент '{client_id}' не найден. Будет выполнена вставка.")
        else:
            print(f"Клиент '{client_id}' найден. Будет выполнено обновление.")


        result = await db.clients.update_one(
            {"client_id": client_id}, # Фильтр: ищем документ с данным client_id
            {"$set": client_data}, # Устанавливаем или обновляем поля из client_data
            upsert=True # Если документа не существует, вставить его
        )

        if result.upserted_id:
            print(f"Клиент '{client_id}' успешно добавлен.")
        elif result.modified_count > 0:
            print(f"Клиент '{client_id}' успешно обновлен.")
        else:
            # Проверяем, если данные не изменились
            if existing_client and all(existing_client.get(k) == v for k, v in client_data.items() if k != "updated_at"):
                 print(f"Клиент '{client_id}' найден, но данные не изменились.")
            else:
                 print(f"Клиент '{client_id}' найден, но изменения не потребовались (возможно, только updated_at изменилось).")


    except Exception as e:
        print(f"Ошибка добавления/обновления клиента {client_id}: {e}", file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
    finally:
        # Закрываем соединение с клиентом MongoDB
        if client_conn:
            client_conn.close()

async def remove_client(client_id):
    """Удаляет клиента и связанные данные из MongoDB."""
    db, client_conn = await get_db() # Получаем соединение с БД
    if not db:
        sys.exit(1) # Завершаем работу, если нет соединения с БД

    if not client_id:
         print("Ошибка: client_id является обязательным для удаления.", file=sys.stderr)
         return # Выходим, если ID клиента отсутствует

    try:
        # Для продакшен CLI инструмента, рассмотрите добавление шага подтверждения удаления.
        # confirm = input(f"Вы уверены, что хотите удалить клиента '{client_id}' и все связанные с ним данные? (yes/no): ")
        # if confirm.lower() != 'yes':
        #     print("Удаление отменено.")
        #     return

        # Удаляем документ клиента
        client_result = await db.clients.delete_one({"client_id": client_id})
        if client_result.deleted_count > 0:
            print(f"Клиент '{client_id}' удален.")
        else:
            print(f"Клиент '{client_id}' не найден.")

        # Удаляем связанные данные (опционально, в зависимости от политики хранения данных)
        # Коллекции из структуры второго скрипта
        print(f"Удаление связанных данных для клиента '{client_id}'...")
        delete_dialogs_result = await db.dialogs.delete_many({"client_id": client_id})
        print(f"Удалено {delete_dialogs_result.deleted_count} записей диалогов.")

        delete_stats_result = await db.stats.delete_many({"client_id": client_id})
        print(f"Удалено {delete_stats_result.deleted_count} записей статистики.")

        delete_forms_result = await db.forms.delete_many({"client_id": client_id})
        print(f"Удалено {delete_forms_result.deleted_count} записей форм.")

        delete_destinations_result = await db.destinations.delete_many({"client_id": client_id}) # Для туризма/green_travel
        print(f"Удалено {delete_destinations_result.deleted_count} записей направлений.")

        delete_services_result = await db.services.delete_many({"client_id": client_id}) # Для beauty_salon
        print(f"Удалено {delete_services_result.deleted_count} записей услуг.")

        delete_n8n_routing_result = await db.n8n_routing.delete_one({"client_id": client_id}) # Удаляем конфигурацию маршрутизации n8n
        if delete_n8n_routing_result.deleted_count > 0:
             print(f"Удалена конфигурация маршрутизации n8n для клиента '{client_id}'.")
        else:
             print(f"Конфигурация маршрутизации n8n для клиента '{client_id}' не найдена.")

        # Решение по webhook_logs (логи аудита) - оставить или удалить?
        # Обычно логи оставляют для аудита, но можно добавить опцию удаления.

        print(f"Удаление связанных данных для клиента '{client_id}' завершено.")

    except Exception as e:
        print(f"Ошибка удаления клиента {client_id} или связанных данных: {e}", file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
    finally:
        # Закрываем соединение с клиентом MongoDB
        if client_conn:
            client_conn.close()

# Базовый интерфейс командной строки для управления клиентами
if __name__ == "__main__":
    # Проверяем, что передан как минимум один аргумент (команда)
    if len(sys.argv) < 2:
        print("Использование:")
        print("  python manage_clients.py add <client_id> <name> <config_file> <business_type> [<persona>] [<tone>] [<messengers_json>]")
        print("  python manage_clients.py remove <client_id>")
        sys.exit(1) # Выходим с кодом ошибки

    command = sys.argv[1] # Получаем команду (add или remove)

    if command == "add":
        # Проверяем количество аргументов для команды add
        # Обязательные: add, client_id, name, config_file, business_type (минимум 5)
        if len(sys.argv) < 6:
            print("Использование: python manage_clients.py add <client_id> <name> <config_file> <business_type> [<persona>] [<tone>] [<messengers_json>]", file=sys.stderr)
            sys.exit(1) # Выходим с кодом ошибки

        # Парсим аргументы
        client_id = sys.argv[2]
        name = sys.argv[3]
        config_file = sys.argv[4]
        business_type = sys.argv[5]
        # Опциональные аргументы с проверкой наличия и значения 'null'
        persona = sys.argv[6] if len(sys.argv) > 6 and sys.argv[6] != 'null' else "дружелюбный помощник"
        tone = sys.argv[7] if len(sys.argv) > 7 and sys.argv[7] != 'null' else "дружелюбный"
        # Аргумент messengers_json опционален, если он последний
        messengers_json = sys.argv[8] if len(sys.argv) > 8 else "{}" # По умолчанию пустой JSON объект


        # Запускаем асинхронную функцию добавления/обновления клиента
        asyncio.run(add_or_update_client(client_id, name, config_file, business_type, persona, tone, messengers_json))

    elif command == "remove":
        # Проверяем количество аргументов для команды remove
        # Обязательные: remove, client_id (минимум 2)
        if len(sys.argv) < 3:
            print("Использование: python manage_clients.py remove <client_id>", file=sys.stderr)
            sys.exit(1) # Выходим с кодом ошибки
        client_id = sys.argv[2] # Получаем ID клиента из аргументов
        # Запускаем асинхронную функцию удаления клиента
        asyncio.run(remove_client(client_id))

    else:
        # Неизвестная команда
        print(f"Неизвестная команда: {command}", file=sys.stderr)
        print("Использование: python manage_clients.py <add|remove> ...", file=sys.stderr)
        sys.exit(1) # Выходим с кодом ошибки
```

log "SUCCESS" "manage_clients.py создан."


log "INFO" "Наполнение файла requirements.txt..."
# requirements.txt (merged, updated for MongoStorage)
cat << 'EOF' > "$PROJECT_DIR/requirements.txt"
aiogram==3.8.0
httpx==0.27.0
pyyaml==6.0.1
motor==3.5.1 # Асинхронный драйвер MongoDB
cachetools==5.5.0 # Для кэширования конфигов
flask==3.0.3 # Для dev GUI
pytest==8.3.2
pytest-asyncio==0.23.8
aiohttp==3.9.5 # Для webhook слушателя WhatsApp и Dev GUI (если используется aiohttp_wsgi)
# pymongo # Не нужен напрямую, motor - это async драйвер
instagrapi==2.1.2 # Для поллинга Instagram (нестабильно для продакшена)
selenium==4.23.1 # Может требоваться instagrapi или другими методами
webdriver-manager==4.0.2 # Может требоваться instagrapi или другими методами
tenacity==8.2.2 # Для логики повторных попыток
loguru==0.7.0 # Для улучшенного логирования
python-dotenv==1.0.0 # Для загрузки .env файла (полезно в локальной разработке/тестировании)
motor-fsm-storage==2.8.0 # Библиотека для FSM хранилища в MongoDB
flask-httpauth==4.1.0 # Для базовой аутентификации Dev GUI
# aiohttp-wsgi # Может потребоваться для запуска Flask app в aiohttp loop (если решите так делать)
EOF

log "SUCCESS" "requirements.txt создан/обновлен."


log "INFO" "Наполнение файла tours.csv..."
# tours.csv (from second script)
cat << 'EOF' > "$PROJECT_DIR/tours.csv"
destination,description,popularity,price
Дубай,солнечно и тепло круглый год,100,500
Турция,приятный климат и пляжи,90,400
Мальдивы,идеально для отдыха на островах,80,800
EOF

log "SUCCESS" "tours.csv создан."


log "INFO" "Наполнение файла .env.example..."
# .env.example (updated)
cat << 'EOF' > "$PROJECT_DIR/.env.example"
# --- AI Agent Platform Merged MVP Environment Variables ---

# Выберите ID клиента для запуска ЭТОГО контейнера ai_agent.
# Если вы запускаете несколько контейнеров ai_agent (по одному на клиента),
# каждый контейнер должен иметь свой CLIENT_ID.
CLIENT_ID=green_travel 

# --- Обязательные переменные ---
# API ключ OpenRouter. Получите его на openrouter.ai
# КРИТИЧЕСКИ ВАЖНО для работы LLM.
OPENROUTER_API_KEY=your_openrouter_api_key 

# --- Учетные данные для мессенджеров ---
# Укажите только те учетные данные, которые нужны для клиента с данным CLIENT_ID,
# и для которых есть соответствующая конфигурация в БД клиента (коллекция 'clients').
# ЭТИ ПЕРЕМЕННЫЕ ОКРУЖЕНИЯ ПЕРЕОПРЕДЕЛЯЮТ ЗНАЧЕНИЯ, ВОЗМОЖНО УКАЗАННЫЕ В БД!
# Хранить здесь секреты ${...} - РИСК БЕЗОПАСНОСТИ для продакшена.
# Используйте более безопасные методы управления секретами (Docker Secrets и т.п.)

TELEGRAM_TOKEN=your_telegram_bot_token # Токен бота Telegram
WHATSAPP_API_KEY=your_whatsapp_evolution_api_key # API ключ для Evolution API
# WHATSAPP_WEBHOOK_BASE_URL - URL, по которому ЭТОТ контейнер ai_agent доступен из Evolution API.
# Если evolution_api в той же сети docker-compose, это обычно http://[service_name]:[internal_port]
# service_name = ai_agent (или уникальный alias, если несколько инстансов ai_agent)
# internal_port = 8080 (порт, который слушает aiohttp в ui/whatsapp_evolution/main.py)
WHATSAPP_WEBHOOK_BASE_URL=http://ai_agent:8080 # Пример для одного контейнера ai_agent

INSTAGRAM_USERNAME=your_instagram_username # Логин Instagram
INSTAGRAM_PASSWORD=your_instagram_password # Пароль Instagram. !!! КРАЙНЕ РИСКОВАНО !!!

MANYCHAT_API_TOKEN=your_manychat_api_token # Токен ManyChat (для интеграции с TikTok)

# --- Учетные данные для Dev GUI ---
# Используются для базовой аутентификации Dev GUI (http://localhost:5000/editor).
# !!! СМЕНИТЕ ПАРОЛИ ПО УМОЛЧАНИЮ !!!
EDITOR_USER=admin
EDITOR_PASSWORD=admin123 
FLASK_SECRET_KEY=replace_with_a_real_secret_key # Секретный ключ Flask для защиты сессий GUI

# --- Настройки N8N ---
# Учетные данные для Basic Auth n8n (для доступа к UI и вызовов webhook)
# Должны совпадать с настройками сервиса n8n в docker-compose.yml.
# !!! СМЕНИТЕ ПАРОЛИ ПО УМОЛЧАНИЮ !!!
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=secure-n8n-password

# --- Настройки MongoDB ---
# Учетные данные для инициализации MongoDB (используются init_mongo и n8n).
# !!! СМЕНИТЕ ПАРОЛИ ПО УМОЛЧАНИЮ !!!
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=admin_password

# --- Прочие настройки приложения ---
LOG_LEVEL=INFO # Уровень логирования (DEBUG, INFO, WARNING, ERROR)
TENACITY_STOP_AFTER_ATTEMPTS=5 # Макс. попыток повтора для внешних вызовов (LLM, N8N)
TENACITY_WAIT_FIXED_SECONDS=3 # Пауза между повторами в секундах
DEFAULT_LANG=en # Язык по умолчанию для системных сообщений i18n, если не определен другой
I18N_PATH=i18n # Путь к директории с файлами локализации JSON (внутри контейнера)

# --- Настройки MongoDB (для внутреннего обращения сервисов) ---
# Обычно менять не требуется, они для обращения сервисов ai_agent, n8n, evolution_api к mongodb.
# MONGO_URI=mongodb://mongodb:27017/ai_agent
# MONGO_DB_NAME=ai_agent

EOF

log "SUCCESS" ".env.example создан."


log "INFO" "Наполнение файла README.md..."
# README.md (updated with all changes)
cat << 'EOF' > "$PROJECT_DIR/README.md"
# AI Agent Platform (Merged MVP)

Многоканальная платформа для AI-агентов с ядром на базе LLM и интеграцией с n8n.
Объединяет структуру из второго варианта проекта с улучшенным ядром обработки из первого варианта,
добавляя персистентность FSM, мультиязычность и базовую аутентификацию GUI.

## Обзор

Эта платформа предоставляет модульное решение для создания AI-агентов, способных обрабатывать сообщения из различных мессенджеров (Telegram, WhatsApp через Evolution API, Instagram, TikTok через ManyChat). Система использует LLM (Language Model) для глубокого понимания запросов и n8n для автоматизации бизнес-процессов на основе структурированных данных от LLM.

### Ключевые особенности

-   **Многоканальность:** Поддержка интеграции с несколькими платформами через отдельные адаптеры (`ui/` модули).
-   **Ядро обработки на базе LLM (LLM-First):** Каждое входящее сообщение (не являющееся частью формы FSM) отправляется в LLM для анализа намерения, извлечения сущностей и предложения действий.
-   **Структурированный JSON-вывод:** LLM всегда возвращает стандартизированный JSON, который передается в n8n для дальнейшей обработки.
-   **Гибкая маршрутизация в n8n:** На основе намерения (intent) и данных сообщения, n8n может запускать различные рабочие процессы (workflows).
-   **Надежность:** Механизмы повторных попыток (`tenacity`) для вызовов LLM и отправки данных в n8n.
-   **Персистентность FSM:** Состояния заполнения форм (FSM) сохраняются в MongoDB (`MongoStorage`), что предотвращает потерю данных при перезапуске сервиса.
-   **Мультиязычность (базовая):** Поддержка системных сообщений (вопросы форм, валидация) на разных языках, выбор языка на основе конфигурации или определения LLM.
-   **Управление клиентами:** Конфигурации клиентов (мессенджеры, настройки LLM, путь к конфигам форм) хранятся в MongoDB.
-   **FSM (Формы):** Возможность определения и выполнения многошаговых форм для сбора структурированных данных (например, для бронирования).
-   **Улучшенное логирование (`loguru`):** Детальные и удобные логи для диагностики.
-   **Dev GUI:** Базовый веб-интерфейс для редактирования YAML конфигураций, защищенный базовой аутентификацией.

## Требования

-   Docker и Docker Compose (последние версии).
-   Доступ к интернету для внешних API (OpenRouter, Evolution API, ManyChat API и др.).
-   API-ключ OpenRouter.
-   Аккаунты и API ключи/токены для используемых мессенджеров (Telegram Bot Token, WhatsApp Evolution API Key/URL, Instagram Credentials, ManyChat API Token).

## Быстрый старт

1.  Сохраните этот скрипт как `setup_project.sh` и сделайте его исполняемым:
    \`\`\`bash
    chmod +x setup_project.sh
    \`\`\`
2.  Запустите скрипт:
    \`\`\`bash
    ./setup_project.sh
    \`\`\`
    Это создаст директорию `ai-agent-platform-merged` со всеми файлами.
3.  Перейдите в директорию проекта:
    \`\`\`bash
    cd ai-agent-platform-merged
    \`\`\`
4.  Создайте файл `.env` в корневой директории проекта на основе файла \`.env.example\`. **Скопируйте содержимое файла `.env.example` в новый файл `.env`** и замените значения по умолчанию на ваши реальные.
5.  **Отредактируйте файл `.env`:**
    *   Установите `CLIENT_ID` - ID клиента, который будет обслуживать **этот конкретный контейнер `ai_agent`**.
    *   **Обязательно** установите `OPENROUTER_API_KEY`.
    *   Укажите API ключи/токены для **тех мессенджеров, которые вы хотите запустить для клиента с данным `CLIENT_ID`** (например, `TELEGRAM_TOKEN`, `WHATSAPP_API_KEY` и т.д.). Переменные окружения переопределяют значения, которые могут быть в БД клиента.
    *   **Обязательно смените пароли по умолчанию для `EDITOR_PASSWORD` и `N8N_BASIC_AUTH_PASSWORD`!**
    *   Установите `WHATSAPP_WEBHOOK_BASE_URL` - это URL, по которому сервис `ai_agent` доступен из сервиса `evolution_api` внутри Docker сети (обычно `http://ai_agent:8080`).
6.  Запустите сервисы с помощью Docker Compose:
    \`\`\`bash
    docker-compose up --build -d
    \`\`\`
    *   `--build` - перестроит образы при необходимости.
    *   `-d` - запустит контейнеры в фоновом режиме.
    *   **Для запуска нескольких клиентов:** Вам нужно скопировать секцию `ai_agent` в `docker-compose.yml` для каждого дополнительного клиента. Дайте каждому сервису уникальное имя (`ai_agent_tourism`, `ai_agent_beauty_salon`), укажите уникальный `container_name`, настройте маппинг портов (если пробрасываете наружу) и, самое главное, установите уникальный `CLIENT_ID` и соответствующие переменные окружения для каждого сервиса `ai_agent`. Убедитесь, что `WHATSAPP_WEBHOOK_BASE_URL` в окружении каждого сервиса указывает на его собственный уникальный алиас в сети Docker.
7.  Проверьте статус запущенных контейнеров:
    \`\`\`bash
    docker-compose ps
    \`\`\`
8.  Проверьте логи контейнеров, особенно `init_mongo` и `ai_agent`, чтобы убедиться, что инициализация прошла успешно и адаптеры запускаются без критических ошибок:
    \`\`\`bash
    docker-compose logs init_mongo # Логи скрипта инициализации БД (выполняется один раз)
    docker-compose logs -f ai_agent # Следить за логами основного приложения AI Agent
    docker-compose logs -f n8n # Логи N8N
    docker-compose logs -f evolution_api # Логи Evolution API
    \`\`\`
    В логах `init_mongo` вы должны увидеть сообщения о добавлении/обновлении клиентов, туров и сервисов. В логах `ai_agent` вы увидите сообщения об инициализации компонентов ядра и запуске сконфигурированных адаптеров.
9.  **Настройте n8n:**
    Откройте n8n по адресу \`http://localhost:5678\`. Войдите с учетными данными (`N8N_BASIC_AUTH_USER`, `N8N_BASIC_AUTH_PASSWORD`) из `.env` файла. Создайте рабочие процессы (workflows) с триггерами "Webhook".
    *   **LLM-обработанные сообщения:** Ядро (`core/n8n_client.py`) будет отправлять полный структурированный JSON-результат от LLM на вебхук по умолчанию `webhook/default` или на путь, настроенный для вашего клиента в коллекции `db.n8n_routing` (например, `webhook/tourism/llm`). Настройте рабочие процессы n8n для приема этих данных и выполнения бизнес-логики (отправка ответов через соответствующее API, создание заявок в CRM, уведомления и т.д.).
    *   **Данные FSM форм:** Заполненные формы отправляются на вебхуки, указанные в YAML файлах конфигурации клиента (например, `http://n8n:5678/webhook/tourism/booking`). Создайте соответствующие вебхуки в n8n для приема данных форм.
10. **Настройте Webhooks в Evolute Manager и ManyChat (если используете):**
    *   **Evolute Manager:** Для каждого подключенного аккаунта WhatsApp клиента, настройте Webhook. URL вебхука должен указывать на внешний адрес вашего сервера и порт, проброшенный на порт `8080` контейнера `ai_agent`, с путем `/webhook/{client_id}`. Например, если ваш сервер доступен по `http://my-server.com` и вы пробросили порт 8080 контейнера `ai_agent` на внешний порт 8080, URL вебхука в Evolute Manager будет `http://my-server.com:8080/webhook/green_travel`.
    *   **ManyChat:** Сконфигурируйте Webhook для интеграции с TikTok в ManyChat (если поддерживается) или используйте их API для получения взаимодействий и отправки ответов, вызывая ваши эндпоинты или используя узлы ManyChat в n8n. **Примечание:** Адаптер TikTok в этом MVP использует placeholder поллинг и может потребовать полной переработки на основе актуальной документации ManyChat API/Webhook.
11. **Доступ к Dev GUI:**
    GUI запускается как часть сервиса `ai_agent` на порту 5000 внутри контейнера. Если вы пробросили порт 5000 наружу (`ports: - "5000:5000"` в docker-compose), он будет доступен по адресу `http://localhost:5000/`. Откройте этот адрес в браузере, выберите клиента, и вы попадете в редактор (`http://localhost:5000/editor?client=client_id`). Вам потребуется ввести учетные данные (`EDITOR_USER`, `EDITOR_PASSWORD`) из `.env`.

## Архитектура

Платформа состоит из следующих сервисов (запускаются в Docker):

-   **ai_agent**: Основной сервис приложения. Запускается ОДИН контейнер на ОДНОГО клиента. Содержит:
    -   **Core Logic** (`main.py`): Инициализация ядра, загрузка конфига клиента, запуск адаптеров.
    -   **Core Router** (`core/router.py`): "Оркестратор". Принимает сообщение из адаптера. Сохраняет историю (пользовательский ввод). Проверяет FSM состояние. Если пользователь в FSM, обрабатывает ввод для формы. Если не в FSM, вызывает Core Processor (LLM). Анализирует результат LLM (особенно 'actions'). Если LLM предложил 'start_fsm', инициирует FSM. Иначе, возвращает текст ответа LLM. Управляет сохранением ответов бота (не LLM) в историю.
    -   **Core Processor** (`core/processor.py`): "Мозг". Получает сообщение (не FSM ввод). Получает полную историю диалога. Формирует промпт для LLM. Вызывает LLM (OpenRouter) с retry. Парсит/валидирует JSON результат (intent, entities, actions, response, language). Сохраняет ответ бота (текст от LLM) И полный LLM-результат в историю. Отправляет полный LLM-результат в n8n с retry. Возвращает полный LLM-результат роутеру.
    -   **Core Database** (`core/database.py`): Инициализация подключения к MongoDB, создание индексов, добавление базовых данных (generic промпт, дефолт n8n routing). Предоставляет доступ к объекту базы данных.
    -   **Core N8n Client** (`core/n8n_client.py`): Надежная (с retry) отправка структурированных данных (результаты LLM) в n8n по webhook'ам. Используется также роутером для отправки данных FSM форм.
    -   **Core I18n** (`core/i18n.py`): Загрузчик локализованных строк для системных сообщений.
    -   **FSM Storage:** MongoDB (`motor-fsm-storage`) используется для персистентного хранения состояний FSM.
    -   **UI/Adapters** (`ui/*`): Отдельные модули для каждого мессенджера (Telegram, WhatsApp, Instagram, TikTok). Взаимодействуют с внешними платформами (получение/отправка сообщений) и передают входящие сообщения в Core Router. Управляют своим экземпляром FSMContext, используя общее хранилище. Адаптер WhatsApp также запускает свой веб-сервер для приема вебхуков.
    -   **Dev GUI** (`dev_gui/editor.py`): Базовый веб-интерфейс для редактирования YAML конфигов форм. Запускается как часть сервиса `ai_agent` и защищен базовой аутентификацией.
-   **mongodb**: База данных для хранения всех данных: конфигураций клиентов, промптов, маршрутизации n8n, истории диалогов, данных форм, логов вебхуков, FSM состояний, данных туров и сервисов.
-   **n8n**: Система автоматизации, получающая структурированные данные от `ai_agent` для выполнения бизнес-логики.
-   **evolution_api**: Сторонний сервис для интеграции с WhatsApp (используется WhatsApp адаптером).
-   **init_mongo**: Вспомогательный сервис, который запускается один раз для первоначального заполнения MongoDB данными клиентов, туров и сервисов.

## Настройка

(См. "Быстрый старт" и файл `.env.example` для информации о переменных окружения)

### YAML Конфигурации (`./configs/*.yaml`)

Каждый клиент имеет свой YAML файл конфигурации (например, `tourism.yaml`), который определяет:
-   `default_response`: Ответы по умолчанию на разных языках.
-   `flows`: Определения FSM форм (потоков). Каждая форма имеет:
    -   Название (например, `booking`).
    -   Тексты вопросов на разных языках.
    -   `steps`: Список шагов, каждый со списком `fields` (полей для сбора).
        -   `name`: Имя поля (используется как ключ).
        -   `validation`: Тип валидации (например, "phone", "number", "" - без валидации).
    -   `submit_to`: URL вебхука в n8n, куда отправляются данные формы.
    -   `thanks`: Сообщения благодарности на разных языках после успешного завершения формы.

### Dev GUI (`http://localhost:5000/editor`)

Веб-интерфейс для редактирования YAML файлов конфигурации. Защищен базовой аутентификацией (учетные данные в `.env`). Позволяет выбрать клиента и редактировать его YAML файл прямо в браузере.

## Риски и Ограничения MVP (Актуально)

-   **Instagram:** Адаптер Instagram использует неофициальную библиотеку `instagrapi` и механизм поллинга, что **крайне ненадежно** и может привести к временным или постоянным блокировкам аккаунта. **Нет персистентного хранения сессий Instagram** и автоматического обхода 2FA/Challenge Required. Используйте на свой страх и риск. Для продакшена рассмотрите официальный API (Instagram Graph API) или проверенные сторонние агрегаторы.
-   **WhatsApp:** Интеграция через Evolution API зависит от этого стороннего сервиса. Убедитесь в его надежности, производительности и соответствии вашим потребностям.
-   **TikTok:** Адаптер TikTok основан на **предположениях о работе ManyChat API** и использует placeholder поллинг. **Скорее всего, он неработоспособен как есть.** Требуется полная переработка на основе актуальной документации ManyChat API/Webhook или другой платформы для работы с TikTok DM.
-   **Безопасность:** Чувствительные данные (API ключи, пароли) хранятся в файле `.env` и передаются в контейнеры через переменные окружения. Это **небезопасно для продакшен-среды**. Следует использовать более безопасные методы управления секретами (Docker Secrets, Kubernetes Secrets, HashiCorp Vault, облачные key vaults). Dev GUI защищен базовой аутентификацией, но учетные данные хранятся в `.env`.
-   **Масштабируемость:** Архитектура "один контейнер `ai_agent` на клиента" может быть неоптимальной для очень большого количества клиентов. При высокой нагрузке может потребоваться горизонтальное масштабирование компонентов (несколько реплик `ai_agent` за балансировщиком, кластер MongoDB, масштабирование n8n и Evolution API).
-   **Обработка ошибок:** Добавлена retry-логика для внешних вызовов (LLM, n8n). Однако, общая отказоустойчивость (например, при сбоях адаптеров, проблем с сетью между контейнерами) требует дальнейшего улучшения (мониторинг, алерты, более сложные стратегии восстановления). Ошибки сохранения истории диалога не останавливают обработку, но могут привести к потере контекста в будущем.
-   **Мультиязычность:** Базовая поддержка системных сообщений реализована с использованием i18n файлов и определения языка (из LLM или по умолчанию). LLM отвечает за генерацию свободного текста ответа на языке пользователя. Тестирование качества определения языка LLM и покрытие всех системных сообщений i18n файлами требует дополнительной работы.
-   **История диалога:** Исправлена схема хранения и базовая логика получения/сохранения. Тестирование на реальных диалогах и разных платформах необходимо.

## Лицензия

MIT
EOF

log "SUCCESS" "README.md создан."

log "SUCCESS" "Все части скрипта объединены и выполнены."
log "SUCCESS" "Весь скрипт настройки AI Agent Platform (Merged MVP) готов."
log "INFO" "Теперь перейдите в директорию '$PROJECT_DIR', настройте файл .env (на основе .env.example) и запустите 'docker-compose up --build -d'."

```
