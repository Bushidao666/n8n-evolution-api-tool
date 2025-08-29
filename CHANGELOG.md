# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-29

### Added
- Initial release of Evolution API Tool for n8n AI Agents
- Support for sending WhatsApp text messages
- Support for sending WhatsApp media messages (images, documents, audio)
- Connection status checking functionality
- WhatsApp profile information retrieval
- AI Agent integration with LangChain tool calling interface
- Dynamic parameter population with `$fromAI()` function support
- Comprehensive error handling with detailed error messages
- Phone number validation and formatting
- SVG icons for visual identification in n8n interface
- Evolution API credentials management
- TypeScript implementation with full type safety
- ESLint and Prettier configuration for code quality
- Comprehensive README with usage examples
- Example AI Agent workflow configuration
- MIT License

### Technical Features
- Built on n8n-workflow APIs
- Compatible with n8n 1.0.0+
- Node.js 20.19-24.x support
- TypeScript 5.5+ compatibility
- Follows n8n AI Agent tool patterns and best practices
- Modular architecture with generic functions for API requests
- Extensible design for future Evolution API features

### Supported Evolution API Endpoints
- `/message/sendText/{instance}` - Text message sending
- `/message/sendMedia/{instance}` - Media file sending  
- `/message/sendWhatsAppAudio/{instance}` - Audio message sending
- `/instance/connectionState/{instance}` - Connection status check
- `/chat/whatsappProfile/{instance}` - Profile information retrieval

### Documentation
- Complete README with installation and usage instructions
- Example workflow for AI Agent integration
- API endpoint documentation
- Error handling guide
- Phone number format specifications
- Development and contribution guidelines