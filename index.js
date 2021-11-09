const AWS = require("aws-sdk");

const REGION = process.env.REGION;
const BUCKET = process.env.BUCKET;
const S3 = new AWS.S3();
const SES = new AWS.SES({
    region: REGION
});

// https://stackoverflow.com/questions/29182244/convert-a-string-to-a-template-string
const fillTemplate = (template, placeholders) => {
    const sanitized = template
        .replace(/\$\{([\s]*[^;\s\{]+[\s]*)\}/g, function(_, match){
            return `\$\{map.${match.trim()}\}`;
        })
        // Afterwards, replace anything that's not ${map.expressions}' (etc) with a blank string.
        .replace(/(\$\{(?!map\.)[^}]+\})/g, '');
    fn = Function('map', `return \`${sanitized}\``);
    return fn(placeholders);
}

const handler = async (event, context) => {
    event.Records.forEach(record => {
        const { key } = JSON.parse(record.body);
        S3.getObject({
            Bucket: BUCKET,
            Key: key
        }, (error, template) => {
            if (error) {
                console.error(error);
                return;
            }

        });
    });
};


module.exports.hander = hander;