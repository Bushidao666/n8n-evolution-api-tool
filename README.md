# n8n Evolution API Tool

[![npm version](https://badge.fury.io/js/n8n-nodes-evolution-api-tool.svg)](https://badge.fury.io/js/n8n-nodes-evolution-api-tool)
[![Build Status](https://github.com/Bushidao666/n8n-evolution-api-tool/workflows/CI%2FCD%20Pipeline/badge.svg)](https://github.com/Bushidao666/n8n-evolution-api-tool/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![n8n Community Node](https://img.shields.io/badge/n8n-Community%20Node-FF6D5A)](https://docs.n8n.io/integrations/community-nodes/)
[![AI Agent Compatible](https://img.shields.io/badge/AI%20Agent-Compatible-4CAF50)](https://docs.n8n.io/ai/)

🚀 **The first and only AI Agent Tool for Evolution API integration with n8n** - WhatsApp automation for AI workflows

## ✨ What Makes This Special

🎯 **Built for AI Agents**: Native LangChain tool integration - not a converted regular node  
🧠 **Intelligent Parameters**: Uses `$fromAI()` for dynamic parameter population by AI  
💬 **Conversational**: AI understands when and how to send WhatsApp messages  
⚡ **Professional**: Follows n8n community node standards and conventions  

## 🆚 How We're Different

| Feature | Other Evolution Nodes | **Our AI Tool** |
|---------|----------------------|------------------|
| **Target** | Manual workflows | 🤖 **AI Agents** |
| **Parameter Handling** | Manual configuration | 🧠 **Dynamic $fromAI()** |
| **Integration** | Standard n8n node | ⚡ **LangChain Tool** |
| **Usage** | Configure each field | 💬 **Conversational AI** |
| **Documentation** | Basic | 📚 **Complete + Examples** |

## 🌟 Features

- **🤖 AI Agent Integration**: Seamlessly works with n8n AI Agents using LangChain tool calling interface
- **📱 WhatsApp Messaging**: Send text messages, images, documents, and audio via WhatsApp Business API
- **🧠 Dynamic Parameters**: Supports `$fromAI()` function for intelligent parameter population by AI agents
- **📊 Connection Monitoring**: Check WhatsApp instance connection status
- **👤 Profile Information**: Retrieve WhatsApp profile data
- **🛡️ Error Handling**: Comprehensive error handling with meaningful messages

## 📋 Supported Operations

### 1. 💬 Send Text Message
Send plain text messages to WhatsApp contacts.

### 2. 📎 Send Media Message
- **🖼️ Images**: Send image files with optional captions
- **📄 Documents**: Send document files with custom filenames
- **🎵 Audio**: Send audio files and voice messages

### 3. 🔗 Check Connection Status
Verify if your WhatsApp instance is connected and ready to send messages.

### 4. 👤 Get Profile Info
Retrieve profile information for any WhatsApp contact.

## 🚀 Installation

### Method 1: Install from npm
```bash
npm install n8n-nodes-evolution-api-tool
```

### Method 2: Development Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/Bushidao666/n8n-evolution-api-tool.git
   cd n8n-evolution-api-tool
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Build the project:
   ```bash
   npm run build
   ```

4. Link to your n8n installation:
   ```bash
   npm link
   cd ~/.n8n/custom
   npm link n8n-nodes-evolution-api-tool
   ```

5. Restart n8n to load the new node.

## ⚙️ Configuration

### Evolution API Credentials
You need to configure Evolution API credentials in n8n:

1. **Base URL**: Your Evolution API server URL (e.g., `https://evolution-api.yourdomain.com`)
2. **API Key**: Your Evolution API key
3. **Instance Name**: Your WhatsApp instance name

### Setting up Evolution API

Evolution API is a powerful WhatsApp Business API solution. To use this tool:

1. **Deploy Evolution API**: Follow the [Evolution API documentation](https://doc.evolution-api.com/) to deploy your own instance
2. **Create Instance**: Create a WhatsApp instance in your Evolution API
3. **Connect WhatsApp**: Connect your WhatsApp account to the instance
4. **Get Credentials**: Note down your API key and instance details

## 🤖 Usage in AI Agent Workflows

### Basic AI Agent Setup

1. **Create Workflow**: Start with a Chat Trigger or Webhook
2. **Add AI Agent**: Add a Tools AI Agent node
3. **Connect Chat Model**: Add your preferred LLM (OpenAI, Anthropic, etc.)
4. **Add Evolution API Tool**: Connect this tool to the AI Agent
5. **Configure Credentials**: Set up your Evolution API credentials

### Example AI Agent Conversation

```
👤 User: "Send a WhatsApp message to +55 11 99999-9999 saying 'Hello from AI!'"

🤖 AI Agent: I'll send that WhatsApp message for you right now.

[AI Agent uses Evolution API Tool with:]
- Operation: Send Text Message  
- Phone Number: 5511999999999
- Message: "Hello from AI!"

✅ Result: Message sent successfully!
```

### 🧠 Dynamic Parameter Population

The tool supports n8n's `$fromAI()` function for intelligent parameter handling:

```typescript
// AI determines phone number from conversation context
phoneNumber: $fromAI('phoneNumber', 'WhatsApp phone number with country code', 'string')

// AI generates message content
messageText: $fromAI('messageContent', 'WhatsApp message to send', 'string')

// AI selects media type based on context
mediaType: $fromAI('mediaType', 'Type of media to send (image/document/audio)', 'string')
```

## 📱 Phone Number Format

**Important**: Phone numbers must include country code without the `+` sign:

- ✅ Correct: `5511999999999` (Brazil)
- ✅ Correct: `1234567890` (US)
- ❌ Wrong: `+55 11 99999-9999`
- ❌ Wrong: `11999999999` (missing country code)

## 🎯 AI Agent Tool Description

The tool automatically provides this description to AI agents:

> "Send WhatsApp messages through Evolution API. Use this tool when you need to send text messages, images, documents, or check WhatsApp connection status via WhatsApp Business API."

You can customize this description in the node settings to better match your specific use case.

## 🔗 API Endpoints Used

This tool interacts with the following Evolution API endpoints:

- `POST /message/sendText/{instance}` - Send text messages
- `POST /message/sendMedia/{instance}` - Send media files
- `POST /message/sendWhatsAppAudio/{instance}` - Send audio messages
- `GET /instance/connectionState/{instance}` - Check connection status
- `POST /chat/whatsappProfile/{instance}` - Get profile information

## 🛡️ Error Handling

The tool provides comprehensive error handling:

- **401 Unauthorized**: Check your API key and permissions
- **404 Not Found**: Verify your base URL and instance name
- **400 Bad Request**: Check phone number format and parameters
- **500 Server Error**: Evolution API server issues

All errors include helpful descriptions to guide troubleshooting.

## 📝 Examples

### Example 1: Simple Text Message
```json
{
  "operation": "sendTextMessage",
  "phoneNumber": "5511999999999",
  "messageText": "Hello! This is an automated message from our AI assistant."
}
```

### Example 2: Send Image with Caption
```json
{
  "operation": "sendMediaMessage",
  "phoneNumber": "5511999999999",
  "mediaType": "image",
  "mediaUrl": "https://example.com/image.jpg",
  "caption": "Here's the image you requested!"
}
```

### Example 3: Send Document
```json
{
  "operation": "sendMediaMessage",
  "phoneNumber": "5511999999999",
  "mediaType": "document",
  "mediaUrl": "https://example.com/report.pdf",
  "filename": "monthly-report.pdf",
  "caption": "Monthly report as requested"
}
```

## 🛠️ Development

### Building
```bash
npm run build
```

### Linting
```bash
npm run lint
npm run lintfix
```

### Formatting
```bash
npm run format
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Run tests and linting: `npm run lint`
5. Commit your changes: `git commit -am 'Add feature'`
6. Push to the branch: `git push origin feature-name`
7. Submit a pull request

## 📋 Requirements

- **n8n**: Version 1.0.0 or higher
- **Node.js**: Version 20.19 to 24.x
- **Evolution API**: Compatible instance

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🆘 Support

- 🐛 **Issues**: [GitHub Issues](https://github.com/Bushidao666/n8n-evolution-api-tool/issues)
- 📖 **Evolution API Docs**: [doc.evolution-api.com](https://doc.evolution-api.com/)
- 📖 **n8n Docs**: [docs.n8n.io](https://docs.n8n.io)

## 🗺️ Roadmap

- [ ] Support for WhatsApp Groups
- [ ] Message templates
- [ ] Webhook support for incoming messages
- [ ] Bulk messaging capabilities
- [ ] Message scheduling
- [ ] Contact management
- [ ] WhatsApp Business Profile management

---

**Made with ❤️ for the n8n community**

🚀 Transform your AI workflows with intelligent WhatsApp messaging capabilities!