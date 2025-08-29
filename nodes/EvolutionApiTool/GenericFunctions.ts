import {
	IDataObject,
	IExecuteFunctions,
	IHttpRequestMethods,
	IRequestOptions,
	NodeApiError,
} from 'n8n-workflow';

/**
 * Make an API request to Evolution API
 */
export async function evolutionApiRequest(
	this: IExecuteFunctions,
	method: IHttpRequestMethods,
	resource: string,
	body: IDataObject = {},
): Promise<any> {
	const credentials = await this.getCredentials('evolutionApi');

	if (!credentials) {
		throw new NodeApiError(this.getNode(), {
			message: 'No Evolution API credentials found',
			description: 'Please configure Evolution API credentials in the node settings',
		});
	}

	const baseUrl = credentials.baseUrl as string;
	const instanceName = credentials.instanceName as string;
	const apiKey = credentials.apiKey as string;

	// Clean up base URL
	const cleanBaseUrl = baseUrl.replace(/\/$/, '');

	// Build full URL with instance name
	let url = `${cleanBaseUrl}${resource}`;

	// Add instance name to URL if not present
	if (!resource.includes('instance/') && instanceName) {
		if (resource.startsWith('/message/') || resource.startsWith('/chat/')) {
			url = `${cleanBaseUrl}${resource}/${instanceName}`;
		}
	} else if (resource.includes('instance/connectionState')) {
		// For connection state, replace placeholder with actual instance name
		url = url.replace('connectionState', `connectionState/${instanceName}`);
	}

	const options: IRequestOptions = {
		headers: {
			'Content-Type': 'application/json',
			'Apikey': apiKey,
		},
		method,
		body,
		url,
		json: true,
	};

	try {
		return await this.helpers.httpRequest(options);
	} catch (error) {
		// Enhanced error handling for common Evolution API errors
		if (error.response) {
			const errorData = error.response.data || error.response.body;
			const statusCode = error.response.status || error.response.statusCode;

			let errorMessage = 'Evolution API request failed';
			let errorDescription = '';

			switch (statusCode) {
				case 401:
					errorMessage = 'Authentication failed';
					errorDescription =
						'Please check your API key and ensure it has the necessary permissions';
					break;
				case 404:
					errorMessage = 'Resource not found';
					errorDescription =
						'Please verify your base URL and instance name are correct';
					break;
				case 400:
					errorMessage = 'Bad request';
					errorDescription =
						errorData?.message ||
						'Please check your request parameters. Phone number should include country code without + sign.';
					break;
				case 500:
					errorMessage = 'Server error';
					errorDescription =
						'Evolution API server encountered an error. Please try again later.';
					break;
				default:
					errorMessage = errorData?.message || `HTTP ${statusCode} Error`;
					errorDescription = errorData?.error || 'Unknown error occurred';
			}

			throw new NodeApiError(this.getNode(), {
				message: errorMessage,
				description: errorDescription,
				httpCode: statusCode.toString(),
				originalError: errorData,
			});
		}

		throw new NodeApiError(this.getNode(), {
			message: 'Evolution API request failed',
			description: error.message || 'An unknown error occurred',
		});
	}
}

/**
 * Format phone number for WhatsApp
 * Ensures phone number is in correct format for Evolution API
 */
export function formatPhoneNumber(phoneNumber: string): string {
	// Remove any non-digit characters
	const cleanNumber = phoneNumber.replace(/\D/g, '');

	// Check if number already has country code
	if (cleanNumber.length >= 10) {
		return cleanNumber;
	}

	// If number is too short, it might be missing country code
	throw new Error(
		`Invalid phone number format: ${phoneNumber}. Please include country code (e.g., 5511999999999)`,
	);
}

/**
 * Validate Evolution API response
 */
export function validateResponse(response: any): boolean {
	if (!response) {
		return false;
	}

	// Check for common Evolution API success indicators
	if (response.key || response.message || response.status === 'success') {
		return true;
	}

	// Check for error indicators
	if (response.error || response.status === 'error') {
		return false;
	}

	// Default to true for unknown response formats
	return true;
}
