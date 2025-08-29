import {
	IAuthenticateGeneric,
	ICredentialTestRequest,
	ICredentialType,
	INodeProperties,
} from 'n8n-workflow';

export class EvolutionApi implements ICredentialType {
	name = 'evolutionApi';
	displayName = 'Evolution API';
	documentationUrl = 'https://doc.evolution-api.com/';
	icon = 'file:evolutionapi.svg';
	properties: INodeProperties[] = [
		{
			displayName: 'Base URL',
			name: 'baseUrl',
			type: 'string',
			default: 'https://yourdomain.com',
			placeholder: 'https://evolution-api.yourdomain.com',
			description: 'The base URL of your Evolution API instance',
			required: true,
		},
		{
			displayName: 'API Key',
			name: 'apiKey',
			type: 'string',
			typeOptions: { password: true },
			default: '',
			placeholder: 'B6D711FCDE4D4FD5936544120E713976',
			description: 'The API key for accessing Evolution API',
			required: true,
		},
		{
			displayName: 'Instance Name',
			name: 'instanceName',
			type: 'string',
			default: '',
			placeholder: 'my-whatsapp-instance',
			description: 'The name of your WhatsApp instance in Evolution API',
			required: true,
		},
	];

	authenticate: IAuthenticateGeneric = {
		type: 'generic',
		properties: {
			headers: {
				'Content-Type': 'application/json',
				Apikey: '={{$credentials.apiKey}}',
			},
		},
	};

	test: ICredentialTestRequest = {
		request: {
			baseURL: '={{$credentials.baseUrl}}',
			url: '/instance/connectionState/={{$credentials.instanceName}}',
			method: 'GET',
		},
	};
}
