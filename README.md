
# 🤖 Create Task by AI

*Automatically generate and manage tasks using AI-powered insights.*

---

## 📚 Table of Contents

- [Overview](#overview)  
- [Features](#features)  
- [Tech Stack](#tech-stack)  
- [Installation](#installation)  
- [Usage](#usage)  
- [Configuration](#configuration)  
- [Contributing](#contributing)  
- [License](#license)  

---

## 📝 Overview

**Create Task by AI** is a smart solution that leverages AI to generate structured tasks from natural language prompts. It’s ideal for enhancing productivity workflows—transforming user ideas, notes, or project requirements into structured to-dos.

---

## ⚙️ Features

- ✍️ **Natural language prompts → task lists**  
- 🔍 **Auto task breakdown and prioritization**  
- 🔄 **Supports exporting tasks to JSON/CSV**  
- 🔗 **Configurable templates for custom formats**  
- 🧠 **Optional OpenAI GPT integration** for advanced parsing  

---

## 🧰 Tech Stack

- **Language & Frameworks:** Python, JavaScript  
- **AI Models:** OpenAI GPT (optional)  
- **Task Storage:** JSON / CSV  
- **Tooling:** Docker (optional)  

---

## ⚙️ Installation

### Clone the repo

```bash
git clone https://github.com/Zia-Ur-Rehman1/Create-Task-by-AI.git
cd Create-Task-by-AI
````

### Create a virtual environment

```bash
python3 -m venv venv
source venv/bin/activate
```

### Install dependencies

```bash
pip install -r requirements.txt
```

---

## 🚀 Usage

### Local run

```bash
python main.py --prompt "Plan a launch campaign for product X"
```

Generates a structured task list from your prompt.

### JSON / CSV export

```bash
python main.py --prompt "..." --format json
python main.py --prompt "..." --format csv
```

---

## ⚙️ Configuration

1. **OpenAI API key (optional)**
   Set in your environment:

   ```bash
   export OPENAI_API_KEY="your-key-here"
   ```

2. **Template customization**
   Edit `config/template.yaml` to adjust formatting or fields.

3. **Docker support**
   Optionally build and run with Docker:

   ```bash
   docker build -t create-task-ai .
   docker run -it create-task-ai --prompt "..." --format json
   ```

---

## 🤝 Contributing

PRs, issues and suggestions are welcome!

1. Fork the repo
2. Create a feature branch
3. Commit with context
4. Submit a PR

---

## ⚖️ License

Licensed under MIT — see [LICENSE](LICENSE) for details.

```
