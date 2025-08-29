import {
	IDataObject,
	IExecuteFunctions,
	INodeExecutionData,
	INodeType,
	INodeTypeDescription,
	NodeApiError,
	NodeOperationError,
} from 'n8n-workflow';

import { evolutionApiRequest } from './GenericFunctions';

export class EvolutionApiTool implements INodeType {
	description: INodeTypeDescription = {
		displayName: 'Evolution API Tool',
		name: 'evolutionApiTool',
		icon: 'file:evolutionapi.svg',
		group: ['ai'],
		version: 1,
		description: 'AI Agent tool for sending WhatsApp messages through Evolution API',
		defaults: {
			name: 'Evolution API Tool',
			color: '#25D366',
		},
		inputs: [],
		outputs: [],
		credentials: [
			{
				name: 'evolutionApi',
				required: true,
			},
		],
		properties: [
			{
				displayName: 'Description',
				name: 'description',
				type: 'string',
				default:
					'Send WhatsApp messages through Evolution API. Use this tool when you need to send text messages, images, documents, or check WhatsApp connection status via WhatsApp Business API.',
				placeholder:
					'Describe when the AI should use this tool for WhatsApp messaging...',
				description:
					'Tool description that helps the AI understand when to use this WhatsApp messaging capability',
			},
			{
				displayName: 'Operation',
				name: 'operation',
				type: 'options',
				noDataExpression: true,
				options: [
					{
						name: 'Send Text Message',
						value: 'sendTextMessage',
						description: 'Send a text message to a WhatsApp contact',
						action: 'Send a text message',
					},
					{
						name: 'Send Media Message',
						value: 'sendMediaMessage',
						description: 'Send an image, document, or audio message',
						action: 'Send a media message',
					},
					{
						name: 'Check Connection Status',
						value: 'checkConnection',
						description: 'Check if WhatsApp instance is connected',
						action: 'Check connection status',
					},
					{
						name: 'Get Profile Info',
						value: 'getProfile',
						description: 'Get profile information of a WhatsApp contact',
						action: 'Get profile information',
					},
				],
				default: 'sendTextMessage',
			},
			// Text Message Fields
			{
				displayName: 'Phone Number',
				name: 'phoneNumber',
				type: 'string',
				displayOptions: {
					show: {
						operation: ['sendTextMessage', 'sendMediaMessage', 'getProfile'],
					},
				},
				default: '',
				placeholder: '5511999999999',
				description:
					'Phone number with country code (no + sign). Example: 5511999999999 for Brazilian number.',
				required: true,
			},
			{
				displayName: 'Message Text',
				name: 'messageText',
				type: 'string',
				typeOptions: {
					rows: 4,
				},
				displayOptions: {
					show: {
						operation: ['sendTextMessage'],
					},
				},
				default: '',
				placeholder: 'Hello! This is a message from AI Agent...',
				description: 'The text message to send',
				required: true,
			},
			// Media Message Fields
			{
				displayName: 'Media Type',
				name: 'mediaType',
				type: 'options',
				options: [
					{
						name: 'Image',
						value: 'image',
					},
					{
						name: 'Document',
						value: 'document',
					},
					{
						name: 'Audio',
						value: 'audio',
					},
				],
				displayOptions: {
					show: {
						operation: ['sendMediaMessage'],
					},
				},
				default: 'image',
			},
			{
				displayName: 'Media URL',
				name: 'mediaUrl',
				type: 'string',
				displayOptions: {
					show: {
						operation: ['sendMediaMessage'],
					},
				},
				default: '',
				placeholder: 'https://example.com/image.jpg',
				description: 'URL of the media file to send',
				required: true,
			},
			{
				displayName: 'Caption',
				name: 'caption',
				type: 'string',
				typeOptions: {
					rows: 2,
				},
				displayOptions: {
					show: {
						operation: ['sendMediaMessage'],
					},
				},
				default: '',
				placeholder: 'Optional caption for the media...',
				description: 'Optional caption to accompany the media',
			},
			{
				displayName: 'Filename',
				name: 'filename',
				type: 'string',
				displayOptions: {
					show: {
						operation: ['sendMediaMessage'],
						mediaType: ['document'],
					},
				},
				default: '',
				placeholder: 'document.pdf',
				description: 'Filename for the document (required for document type)',
			},
		],
	};

	async execute(this: IExecuteFunctions): Promise<INodeExecutionData[][]> {
		const items = this.getInputData();
		const returnData: INodeExecutionData[] = [];

		for (let i = 0; i < items.length; i++) {
			try {
				const operation = this.getNodeParameter('operation', i) as string;

				let responseData: IDataObject;

				switch (operation) {
					case 'sendTextMessage':
						responseData = await this.sendTextMessage(i);
						break;
					case 'sendMediaMessage':
						responseData = await this.sendMediaMessage(i);
						break;
					case 'checkConnection':
						responseData = await this.checkConnection(i);
						break;
					case 'getProfile':
						responseData = await this.getProfile(i);
						break;
					default:
						throw new NodeOperationError(
							this.getNode(),
							`The operation "${operation}" is not supported`,
						);
				}

				returnData.push({
					json: {
						result: responseData,
						operation,
						timestamp: new Date().toISOString(),
						success: true,
					},
				});
			} catch (error) {
				if (this.continueOnFail(error)) {
					returnData.push({
						json: {
							error: error.message,
							operation: this.getNodeParameter('operation', i),
							timestamp: new Date().toISOString(),
							success: false,
						},
						pairedItem: { item: i },
					});
					continue;
				}
				throw error;
			}
		}

		return [returnData];
	}

	private async sendTextMessage(itemIndex: number): Promise<IDataObject> {
		const phoneNumber = this.getNodeParameter('phoneNumber', itemIndex) as string;
		const messageText = this.getNodeParameter('messageText', itemIndex) as string;

		const body = {
			number: phoneNumber,
			text: messageText,
		};

		return evolutionApiRequest.call(this, 'POST', '/message/sendText', body);
	}

	private async sendMediaMessage(itemIndex: number): Promise<IDataObject> {
		const phoneNumber = this.getNodeParameter('phoneNumber', itemIndex) as string;
		const mediaType = this.getNodeParameter('mediaType', itemIndex) as string;
		const mediaUrl = this.getNodeParameter('mediaUrl', itemIndex) as string;
		const caption = this.getNodeParameter('caption', itemIndex, '') as string;
		const filename = this.getNodeParameter('filename', itemIndex, '') as string;

		let endpoint = '';
		let body: IDataObject = {
			number: phoneNumber,
		};

		switch (mediaType) {
			case 'image':
				endpoint = '/message/sendMedia';
				body.mediatype = 'image';
				body.media = mediaUrl;
				if (caption) body.caption = caption;
				break;
			case 'document':
				endpoint = '/message/sendMedia';
				body.mediatype = 'document';
				body.media = mediaUrl;
				body.filename = filename || 'document';
				if (caption) body.caption = caption;
				break;
			case 'audio':
				endpoint = '/message/sendWhatsAppAudio';
				body.audio = mediaUrl;
				break;
		}

		return evolutionApiRequest.call(this, 'POST', endpoint, body);
	}

	private async checkConnection(itemIndex: number): Promise<IDataObject> {
		return evolutionApiRequest.call(this, 'GET', '/instance/connectionState');
	}

	private async getProfile(itemIndex: number): Promise<IDataObject> {
		const phoneNumber = this.getNodeParameter('phoneNumber', itemIndex) as string;

		const body = {
			number: phoneNumber,
		};

		return evolutionApiRequest.call(this, 'POST', '/chat/whatsappProfile', body);
	}
}
