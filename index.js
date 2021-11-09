const AWS = require("aws-sdk");

const REGION = process.env.REGION;
const BUCKET = process.env.BUCKET;
const DOMAIN = process.env.DOMAIN;
const SQS_URL = process.env.SQS_URL;

const S3 = new AWS.S3();
const SES = new AWS.SES({
	region: REGION
});
const SQS = new AWS.SQS({
	apiVersion: '2012-11-05'
})

// https://stackoverflow.com/questions/29182244/convert-a-string-to-a-template-string
const constructTemplate = (() => {
	let cache = {};

	return (template) => {
		if (cache[template]) {
			return cache[template];
		}

		const sanitized = template
			.replace(/\$\{([\s]*[^;\s\{]+[\s]*)\}/g, function(_, match){
				return `\$\{map.${match.trim()}\}`;
			})
			// Afterwards, replace anything that's not ${map.expressions}' (etc) with a blank string.
			.replace(/(\$\{(?!map\.)[^}]+\})/g, '');
		fn = Function('map', `return \`${sanitized}\``);
		cache[template] = fn;

		return fn;
	}
})();

const handler = async (event, context) => {
	event.Records.forEach(record => {
		const { key, placeholders, toAddresses, ccAddresses, title, agent } = JSON.parse(record.body);
		S3.getObject({
			Bucket: BUCKET,
			Key: key
		}, (error, template) => {
			if (error) {
				console.error(error);
				return;
			}
			const constructedTemplate = constructTemplate(template);
			const emailBody = constructedTemplate(placeholders);

			const SESParams = {
				Destination: {
					ToAddresses: toAddresses,
					CcAddresses: ccAddresses
				},
				Message: {
					Body: {
						Html: {
							Charset: "UTF-8",
							Data: emailBody
						}
					},
					Subject: {
						Charset: 'UTF-8',
						Data: title
					}
				},
				Source: `${agent}@${DOMAIN}`
			};

			SES.sendEmail(SESParams)
				.promise()
				.then(result => {
					console.log("Send Email Sucessfully");
					SQS.sendMessage({
						DelaySeconds: 10,
						MessageBody: "sucess",
						QueueUrl: SQS_URL
					});
				})
				.catch(error => {
					console.log("Error Sending Email");
					console.log(error);

					SQS.sendMessage({
						DelaySeconds: 10,
						MessageBody: "error",
						QueueUrl: SQS_URL
					});
				});
		});
	});
};

module.exports.handler = handler;