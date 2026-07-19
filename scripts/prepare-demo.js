const fs = require("fs");
const path = require("path");

const envPath = path.join(__dirname, "..", "server", ".env");
const envExamplePath = path.join(__dirname, "..", "server", ".env.example");

const fallbackEnv = [
  'DATABASE_URL="mysql://root:@localhost:3306/crm_mini_xampp"',
  'JWT_SECRET="crm-mini-xampp-demo-secret"',
  "PORT=4000",
  "HOST=0.0.0.0",
  ""
].join("\n");

function writeEnv(reason) {
  const content = fs.existsSync(envExamplePath)
    ? fs.readFileSync(envExamplePath, "utf8")
    : fallbackEnv;
  fs.writeFileSync(envPath, content);
  console.log(`${reason} server/.env for XAMPP MySQL use.`);
}

if (!fs.existsSync(envPath)) {
  writeEnv("Created");
} else {
  const current = fs.readFileSync(envPath, "utf8");
  const usesMysql = /DATABASE_URL\s*=\s*["']?mysql:\/\//.test(current);
  const usesXamppDb = current.includes("crm_mini_xampp");

  if (!usesMysql || !usesXamppDb) {
    const backupPath = `${envPath}.backup`;
    if (!fs.existsSync(backupPath)) {
      fs.copyFileSync(envPath, backupPath);
    }
    writeEnv("Updated");
  } else {
    console.log("server/.env already uses XAMPP MySQL.");
  }
}
