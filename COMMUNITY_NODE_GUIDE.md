# n8n Community Node Guide

Este guia explica como transformar este projeto em um Community Node oficial do n8n e publicá-lo no npm.

## ✅ Já Implementado

### Estrutura de Community Node
- ✅ **Keyword obrigatória**: `n8n-community-node-package` adicionada ao package.json
- ✅ **Dependências corretas**: n8n-workflow e n8n-core em devDependencies
- ✅ **Arquivo index.js**: Entry point para o package
- ✅ **Configuração n8n**: Seção n8n no package.json com paths corretos
- ✅ **Build system**: Gulp para build de ícones, TypeScript para compilação
- ✅ **Estrutura de arquivos**: nodes/ e credentials/ organizados corretamente

### Arquivos Community Node
- ✅ **package.json**: Configurado com keyword e dependências corretas
- ✅ **index.js**: Entry point vazio (n8n carrega automaticamente)
- ✅ **gulpfile.js**: Build de ícones SVG
- ✅ **tsconfig.json**: Configuração TypeScript compatível com n8n
- ✅ **.eslintrc.js**: Linting com regras n8n-nodes-base
- ✅ **SVG Icons**: Ícones para node e credentials

## 📦 Publicando como Community Node

### Pré-requisitos
1. **Conta npm**: Registre-se em [npmjs.com](https://www.npmjs.com)
2. **npm CLI**: Instale e faça login `npm login`
3. **Testes locais**: Teste o build e funcionalidade

### Passo a Passo

#### 1. Build e Validação
```bash
# Clone e setup
git clone https://github.com/Bushidao666/n8n-evolution-api-tool.git
cd n8n-evolution-api-tool
npm install

# Build e testes
npm run build
npm run lint
npm pack
```

#### 2. Teste Local no n8n
```bash
# Instale o package localmente
npm link

# No diretório n8n
cd ~/.n8n/custom
npm link n8n-nodes-evolution-api-tool

# Restart n8n
n8n start
```

#### 3. Verificar no n8n
- ✅ Credenciais "Evolution API" aparecem na lista
- ✅ Node "Evolution API Tool" aparece em AI > Tools
- ✅ Node funciona com AI Agent
- ✅ Ícones aparecem corretamente

#### 4. Publicar no npm
```bash
# Verifique se está tudo correto
npm run prepublishOnly

# Publique (primeira vez)
npm publish

# Para updates
npm version patch  # ou minor, major
npm publish
```

### 5. Após a Publicação

#### No npmjs.com
Seu package aparecerá em: `https://www.npmjs.com/package/n8n-nodes-evolution-api-tool`

#### Instalação pelos usuários
```bash
# Via npm
npm install n8n-nodes-evolution-api-tool

# Via n8n CLI
n8n install n8n-nodes-evolution-api-tool
```

#### No n8n Community Nodes
O n8n automaticamente detectará seu package e pode incluí-lo na lista oficial de Community Nodes.

## 🔧 Configurações Importantes

### package.json - Seções Críticas
```json
{
  "keywords": [
    "n8n-community-node-package",  // OBRIGATÓRIO!
    "n8n",
    "evolution-api",
    "whatsapp"
  ],
  "main": "index.js",  // Entry point
  "files": ["dist"],   // Apenas dist/ no package
  "n8n": {              // Configuração n8n
    "n8nNodesApiVersion": 1,
    "credentials": ["dist/credentials/EvolutionApi.credentials.js"],
    "nodes": ["dist/nodes/EvolutionApiTool/EvolutionApiTool.node.js"]
  }
}
```

### Estrutura de Arquivos Obrigatória
```
n8n-nodes-evolution-api-tool/
├── package.json          # Com keyword community-node
├── index.js             # Entry point
├── gulpfile.js          # Build icons
├── tsconfig.json        # TypeScript config
├── credentials/
│   ├── EvolutionApi.credentials.ts
│   └── evolutionapi.svg
├── nodes/
│   └── EvolutionApiTool/
│       ├── EvolutionApiTool.node.ts
│       ├── GenericFunctions.ts
│       └── evolutionapi.svg
└── dist/               # Build output
    ├── credentials/
    └── nodes/
```

## 🚀 Recursos Community Node

### Vantagens
1. **Descoberta automática**: Usuários encontram via n8n Community
2. **Instalação simples**: `npm install` ou via n8n interface
3. **Updates automáticos**: npm update funciona
4. **Documentação centralizada**: README aparece no npmjs.com
5. **Estatísticas**: Downloads e uso via npmjs.com

### Requisitos de Qualidade
- ✅ **README completo**: Instruções de instalação e uso
- ✅ **Exemplos**: Workflows de exemplo inclusos
- ✅ **Error handling**: Tratamento robusto de erros
- ✅ **TypeScript**: Tipagem completa
- ✅ **Testes**: Build e lint sem erros
- ✅ **Documentação**: Comentários no código

## 🐛 Troubleshooting

### Problemas Comuns

#### "Package not found"
- ✅ Verificar keyword `n8n-community-node-package`
- ✅ Verificar se foi publicado: `npm view n8n-nodes-evolution-api-tool`

#### "Node not appearing"
- ✅ Verificar paths no package.json seção n8n
- ✅ Verificar se dist/ existe e tem os .js files
- ✅ Restart n8n após instalação

#### "Build errors"
- ✅ Verificar dependências: n8n-workflow, n8n-core
- ✅ Verificar TypeScript config
- ✅ Verificar se todos imports estão corretos

### Logs e Debug
```bash
# Debug npm
npm pack --dry-run
npm publish --dry-run

# Debug n8n
N8N_LOG_LEVEL=debug n8n start

# Debug build
npm run build -- --verbose
```

## 📈 Próximos Passos

1. **✅ Teste extensivo**: Teste todas as operações
2. **🔄 Publique v1.0.0**: Primera versão estável
3. **📢 Divulgue**: Compartilhe na comunidade n8n
4. **🐛 Colete feedback**: Issues no GitHub
5. **🚀 Iterate**: Melhore baseado no feedback

---

**Status**: ✅ **PRONTO PARA PUBLICAÇÃO** 

Este projeto está configurado corretamente como Community Node e pronto para ser publicado no npm!
