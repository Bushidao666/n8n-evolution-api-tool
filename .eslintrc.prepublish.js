const sharedOptions = require('./.eslintrc.js');

module.exports = {
	...sharedOptions,
	rules: {
		...sharedOptions.rules,
		'n8n-nodes-base/node-class-description-inputs-wrong-regular-node': 'off',
		'n8n-nodes-base/node-class-description-outputs-wrong': 'off',
	},
};
