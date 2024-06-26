1. Create a project directory

          mkdir nodejs-app
          cd nodejs-app

2. Initialize a new Node.js project

          npm init -y

3. Install Express and other dependencies

          npm install express
          npm install --save-dev mocha chai eslint

4. Create the Express application:
   Create a file named app.js and add the following code:

          const express = require('express');
          const app = express();
          
          app.get('/', (req, res) => {
            res.send('Hello, Heroku!');
          });
          
          const PORT = process.env.PORT || 3000;
          app.listen(PORT, () => {
            console.log(`Server is running on port ${PORT}`);
          });
          
          module.exports = app;

5. Create a test file:
   Create a directory named test and inside it, create a file named test.js:

          const chai = require('chai');
          const chaiHttp = require('chai-http');
          const app = require('../app');
          const { expect } = chai;
          
          chai.use(chaiHttp);
          
          describe('GET /', () => {
            it('should return Hello, Heroku!', (done) => {
              chai.request(app)
                .get('/')
                .end((err, res) => {
                  expect(res).to.have.status(200);
                  expect(res.text).to.equal('Hello, Heroku!');
                  done();
                });
            });
          });


6. Add ESLint configuration:
   Create a file named .eslintrc.json:

          {
            "env": {
              "node": true,
              "mocha": true,
              "es6": true
            },
            "extends": "eslint:recommended",
            "rules": {
              "no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
              "no-console": "off"
            }
          }

7. Update package.json:
   Add scripts for testing and linting:

          "scripts": {
            "start": "node app.js",
            "test": "mocha",
            "lint": "eslint ."
          }


8. Set Up GitHub Actions
   Create a GitHub repository for your project and push the code to GitHub.

   Create a GitHub Actions workflow:
   In your project directory, create a directory named .github/workflows and inside it, create a file named ci.yml:


          name: Node.js CI
          
          on:
            push:
              branches: [ main ]
            pull_request:
              branches: [ main ]
          
          jobs:
            build:
          
              runs-on: ubuntu-latest
          
              strategy:
                matrix:
                  node-version: [14.x, 16.x, 18.x]
          
              steps:
              - name: Checkout code
                uses: actions/checkout@v2
          
              - name: Use Node.js ${{ matrix.node-version }}
                uses: actions/setup-node@v2
                with:
                  node-version: ${{ matrix.node-version }}
          
              - name: Install dependencies
                run: npm install
          
              - name: Run tests
                run: npm test
          
              - name: Run linter
                run: npm run lint
          
              - name: Deploy to Heroku
                if: github.ref == 'refs/heads/main'
                run: |
                  npm install -g heroku
                  echo "machine api.heroku.com login ${{ secrets.HEROKU_EMAIL }} password ${{ secrets.HEROKU_API_KEY }}" > ~/.netrc
                  echo "machine git.heroku.com login ${{ secrets.HEROKU_EMAIL }} password ${{ secrets.HEROKU_API_KEY }}" >> ~/.netrc
                  git remote add heroku https://git.heroku.com/${{ secrets.HEROKU_APP_NAME }}.git
                  git push heroku main

9. Set up GitHub Secrets:
   Go to your GitHub repository settings, navigate to "Secrets and variables" > "Actions", and add the following secrets:

          HEROKU_EMAIL: Your Heroku account email.
          HEROKU_API_KEY: Your Heroku API key (found in your Heroku account settings).
          HEROKU_APP_NAME: The name of your Heroku app.


10. Deploy to Heroku

    Create a Heroku app:
    If you haven't already, create a new Heroku app:

          heroku create your-heroku-app-name


Add a Procfile:
In your project directory, create a file named Procfile and add the following line:


Push the Code to GitHub

          git add .
          git commit -m "Initial commit"
          git push origin main

