const http = require('http');
const fs = require('fs');
const util = require('util');
const path = require('path');

const port = 9898;

const readFileAsync = util.promisify(fs.readFile);

const { createWriteStream } = require('fs');

const logFilePath = 'log.txt';

(function setupLogging() {

  if (!fs.existsSync(logFilePath)) {
    fs.writeFileSync(logFilePath, '');
  }

  const logStream = createWriteStream(logFilePath, { flags: 'a' });

  const originalConsoleLog = console.log;
  console.log = function(...args) {
    logStream.write(args.join(' ') + '\n');
    originalConsoleLog.apply(console, args);
  };

  process.on('exit', () => {
    logStream.end();
  });
})();

function getDate() {
    const now = new Date();
    const formattedDate = `${(now.getMonth() + 1).toString().padStart(2, '0')}/${now.getDate().toString().padStart(2, '0')}/${now.getFullYear()} ${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}:${now.getSeconds().toString().padStart(2, '0')}.${now.getMilliseconds().toString().padStart(3, '0')}`;
    return formattedDate;
}

function sleepSync(ms){
  const start= Date.now();
  while (Date.now() - start < ms) {

  };
}

function readJsonFile(api, userId, code, error, errorCode, moreInformation) {
    let fileName;
    if (code !== 200) {
        fileName = `${userId}/error/${api}.json`;
    } else {
        fileName = `${userId}/${api}.json`;
    }
    const filePath = `${__dirname}/${fileName}`;

    return readFileAsync(filePath, 'utf-8')
        .then(data => {
            let jsonData = JSON.parse(data);
            if (code !== 200) {
                jsonData.error = error;
                jsonData.errorCode = errorCode;
                jsonData.moreInformation = moreInformation;
            }
            console.log(`${getDate()} File read successfully: ${filePath}`);
            return jsonData;
        })
        .catch(error => {
            console.log(`${getDate()} Error reading JSON file: ${filePath}\n${error}`);
            return { errorCode: 'Internal Server Error' };
        });
}

function getMimeType(ext) {
    const mimeTypes = {
        '.html': 'text/html',
        '.css': 'text/css',
        '.js': 'application/javascript',
        '.json': 'application/json',
        '.png': 'image/png',
        '.jpg': 'image/jpeg',
        '.gif': 'image/gif',
		'.mp3': 'audio/mpeg',
		'.mp4': 'video/mp4',
		'.mpeg': 'video/mpeg',
        '.txt': 'text/plain'
    };
    return mimeTypes[ext] || 'application/octet-stream';
}

function handleFileRequest(filePath, res) {
    const ext = path.extname(filePath);
    const mimeType = getMimeType(ext);

    readFileAsync(filePath)
        .then(content => {
            res.writeHead(200, { 'Content-Type': mimeType });
            res.end(content);
            console.log(`${getDate()} Response Body: File ${filePath} served`);
        })
        .catch(error => {
            console.log(`${getDate()} Error reading file: ${filePath}\n${error}`);
            res.writeHead(404, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ message: 'File Not Found' }));
        });
}

const server = http.createServer((req, res) => {
    handleRequest(req, res).catch(error => {
        console.error(`${getDate()} Error handling request: ${error}`);
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ errorCode: 'Internal Server Error' }));
    });
});

async function handleRequest(req, res) {
    const userId = req.headers['user-id'];
    console.log(`${getDate()} Request -----------------------------------------${userId}`);

    if (req.method === 'GET' || req.method === 'POST' || req.method === 'DELETE') {
        let filePath = `${userId}/config.json`;
        if (!userId) {
            filePath = 'config.json';
        }

        filePath = `${__dirname}/${filePath}`;

        const data = await readFileAsync(filePath, 'utf-8');
        const configJson = JSON.parse(data);

        console.log(`${getDate()} Received ${req.method} request for URL: ${req.url} HTTP/${req.httpVersion}`);
        console.log(`${getDate()} Request Headers: ${JSON.stringify(req.headers)}`);

        if (req.method === 'POST') {
            await new Promise((resolve, reject) => {
                let body = '';
                req.on('data', chunk => {
                    body += chunk.toString();
                });

                req.on('end', () => {
                    console.log(`${getDate()} Request Body: ${body}`);
                    resolve(body); // Resolve the promise when 'end' event is triggered
                });
            });
        }

        const pathParts = req.url.split('?')[0].split('/').filter(part => part);
        let api = pathParts[pathParts.length - 1];
        let errorCode = null;
        let moreInformation = null;
        let timeout = null;
		let matched = false;
        for (const item of configJson) {
            if (item.api === api) {
				matched = true;
                let code = item.httpCode || 200;
                errorCode = item.errorCode;
                moreInformation = item.moreInformation;
                timeout = item.timeout;

                if (code !== 200) {
                    api = String(code);
                }
                if (errorCode) {
                    api = String(errorCode);
                }
                if (Number.isInteger(timeout)) {

                }else{
                    timeout = 0;
                }

                const error = item.error;
                const request_body = (req.method === 'POST'||req.method === 'DELETE') ? req.body : req.query;

                if (api.toLowerCase().includes('timeout')) {
                    setTimeout(() => {
                        console.log('Timeout');
                        res.writeHead(500, { 'Content-Type': 'application/json' });
                        res.end(JSON.stringify({ errorCode: 'Timeout' }));
                    }, 11000);
                } else {
                    try {
                        console.log(`timeout=` + timeout);
                    	sleepSync(timeout);
                        const result = await readJsonFile(api, userId, code, error, errorCode, moreInformation);
                        res.setHeader('Set-Cookie',
                            ['name=JohnDoe; Path=/; HttpOnly',
                                'JSESSIONID=fasvsbgfgbfdgvsdfgbg.asdfhaoie; Path=/; HttpOnly',
                                'token=abc123; Path=/; Secure; Max-Age=3600']);
                        res.writeHead(code, { 'Content-Type': 'application/json', 'x-cloud-trace-context': '9527' });
                        const jsonResult = JSON.stringify(result);
                        res.end(jsonResult);
                        console.log(`${getDate()} Response Body: ${jsonResult}`);
                    } catch (error) {
                        console.log(`${getDate()} Error reading JSON file: ${filePath}\n${error}`);
                        res.writeHead(500, { 'Content-Type': 'application/json' });
                        res.end(JSON.stringify({ errorCode: 'Internal Server Error' }));
                    }
                }
                break;
            }
        }

		if (!matched) {
			if(!api.includes(".")) {
				console.log(`${getDate()} Can not found config: ${api}`);
				res.writeHead(404, { 'Content-Type': 'application/json' });
				res.end(JSON.stringify({ message: 'Internal Server Error' }));
				return;
			}
			const fileName = `${userId}/api/file/${api}`;
			const filePath = `${__dirname}/${fileName}`;
			// const filePath = path.join(__dirname, req.url);
			console.log(`${getDate()} This is file request: ${filePath}`);
			handleFileRequest(filePath, res);
		}

    } else {
        console.log(`Invalid HTTP method for URL: ${req.url}`);
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ errorCode: 'Internal Server Error' }));
    }
}

server.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});


