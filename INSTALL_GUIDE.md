# Installation Guide - Evolution API Tool

🚀 Multiple ways to install and use the Evolution API Tool for n8n AI Agents.

## 📦 Method 1: npm Install (Recommended)

### For n8n Cloud Users
```bash
# Install globally
npm install -g n8n-nodes-evolution-api-tool

# Or install locally in n8n directory
cd ~/.n8n
npm install n8n-nodes-evolution-api-tool
```

### For Self-hosted n8n
```bash
# In your n8n installation directory
npm install n8n-nodes-evolution-api-tool

# Restart n8n
sudo systemctl restart n8n
# or
pm2 restart n8n
```

## 🛠️ Method 2: Development Install

### Prerequisites
- Node.js 20.19-24.x
- npm or yarn
- Git

### Steps
```bash
# 1. Clone repository
git clone https://github.com/Bushidao666/n8n-evolution-api-tool.git
cd n8n-evolution-api-tool

# 2. Install dependencies
npm install

# 3. Build project
npm run build

# 4. Link to n8n (choose one option below)
```

#### Option A: Link globally
```bash
npm link

# In n8n directory
cd ~/.n8n
npm link n8n-nodes-evolution-api-tool
```

#### Option B: Copy to n8n custom directory
```bash
# Create custom nodes directory
mkdir -p ~/.n8n/custom
cd ~/.n8n/custom

# Copy built files
cp -r /path/to/n8n-evolution-api-tool/dist ./n8n-nodes-evolution-api-tool
cp /path/to/n8n-evolution-api-tool/package.json ./n8n-nodes-evolution-api-tool/
```

## 🐳 Method 3: Docker Install

### For n8n Docker
```bash
# Create volume for custom nodes
docker volume create n8n_custom_nodes

# Install in running container
docker exec -it n8n_container npm install n8n-nodes-evolution-api-tool

# Or build with custom Dockerfile
```

### Custom Dockerfile
```dockerfile
FROM n8nio/n8n:latest

# Install custom node
USER root
RUN npm install -g n8n-nodes-evolution-api-tool
USER node
```

## ⚙️ Configuration

### 1. Setup Evolution API Credentials

After installation, configure your Evolution API credentials in n8n:

1. **Go to**: Settings → Credentials → Add Credential
2. **Search**: "Evolution API"
3. **Configure**:
   - **Base URL**: `https://your-evolution-api-domain.com`
   - **API Key**: Your Evolution API key
   - **Instance Name**: Your WhatsApp instance name

### 2. Verify Installation

1. **Check Credentials**: Evolution API should appear in credentials list
2. **Check Nodes**: Evolution API Tool should appear in AI > Tools category
3. **Test Connection**: Use "Check Connection Status" operation

## 🤖 Setting up AI Agent Workflow

### Basic Workflow Structure
```
Chat Trigger → AI Agent → Chat Model
                    ↓
            Evolution API Tool
                    ↓ 
            Memory (optional)
                    ↓
            Output Parser (optional)
```

### Step by Step

1. **Add Chat Trigger**
   - Configure webhook or chat interface

2. **Add AI Agent (Tools Agent)**
   - Set prompt for WhatsApp assistant
   - Connect other components

3. **Add Chat Model**
   - OpenAI GPT-4, Anthropic Claude, etc.
   - Connect to AI Agent

4. **Add Evolution API Tool**
   - Select credential
   - Connect to AI Agent
   - Configure default operation

5. **Test the Workflow**
   - Send test message: "Send WhatsApp to +5511999999999 saying Hello!"
   - Verify AI uses the tool correctly

## 🔧 Troubleshooting

### Installation Issues

#### "Module not found"
```bash
# Check if installed
npm list n8n-nodes-evolution-api-tool

# Reinstall if needed
npm uninstall n8n-nodes-evolution-api-tool
npm install n8n-nodes-evolution-api-tool
```

#### "Node not appearing"
1. **Restart n8n completely**
2. **Check n8n logs** for loading errors
3. **Verify file permissions** in ~/.n8n directory
4. **Clear n8n cache**: Delete ~/.n8n/cache/

#### "Credentials not available"
1. **Check installation method** - credentials load with nodes
2. **Verify package.json** n8n section includes credentials path
3. **Check file paths** in dist/credentials/

### Runtime Issues

#### "Authentication Failed"
- ✅ Check API key is correct
- ✅ Verify base URL format: `https://domain.com` (no trailing slash)
- ✅ Ensure instance name matches Evolution API
- ✅ Test credentials with Evolution API directly

#### "Phone number format error"
- ✅ Use country code without + sign: `5511999999999`
- ✅ Remove spaces, hyphens, parentheses
- ✅ Verify number is valid WhatsApp number

#### "Media upload fails"
- ✅ Check media URL is publicly accessible
- ✅ Verify file format is supported
- ✅ Check file size limits
- ✅ Test URL in browser first

### Performance Issues

#### "Slow responses"
- ✅ Check Evolution API server performance
- ✅ Verify network latency to Evolution API
- ✅ Monitor n8n server resources
- ✅ Check WhatsApp rate limits

#### "Memory usage"
- ✅ Monitor n8n memory usage
- ✅ Restart n8n periodically if needed
- ✅ Check for memory leaks in logs

## 📊 Monitoring

### Logs to Monitor
```bash
# n8n logs
tail -f ~/.n8n/logs/n8n.log

# Evolution API logs
# Check your Evolution API server logs

# System logs
journalctl -u n8n -f
```

### Health Checks
- ✅ Test "Check Connection Status" operation daily
- ✅ Monitor message delivery success rate
- ✅ Check Evolution API server health
- ✅ Verify WhatsApp instance connection

## 🆕 Updates

### Update Community Node
```bash
# Check current version
npm list n8n-nodes-evolution-api-tool

# Update to latest
npm update n8n-nodes-evolution-api-tool

# Restart n8n
sudo systemctl restart n8n
```

### Development Updates
```bash
cd n8n-evolution-api-tool
git pull origin main
npm install
npm run build

# If linked:
npm run build
# n8n will auto-reload
```

## 🆘 Getting Help

### Documentation
- 📖 **README**: [Project README](https://github.com/Bushidao666/n8n-evolution-api-tool)
- 🔗 **Evolution API Docs**: [doc.evolution-api.com](https://doc.evolution-api.com/)
- 📚 **n8n Docs**: [docs.n8n.io](https://docs.n8n.io)

### Support Channels
- 🐛 **GitHub Issues**: [Report bugs](https://github.com/Bushidao666/n8n-evolution-api-tool/issues)
- 💬 **n8n Community**: [community.n8n.io](https://community.n8n.io)
- 📧 **Evolution API Support**: Check their documentation

### Before Reporting Issues
1. ✅ Check this installation guide
2. ✅ Verify Evolution API is working directly
3. ✅ Test with simple WhatsApp message first
4. ✅ Include logs and error messages in report
5. ✅ Specify versions: n8n, Node.js, Evolution API

---

**Happy WhatsApp automation with AI! 🚀**