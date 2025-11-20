import { StrictMode } from "react";
import { createRoot } from "react-dom/client";

// App Entry
import App from "./app/app";
import { WalletProvider } from "./providers/WalletProvider";
import "./index.css";

// Main entry point
function main() {
  const rootElement = document.getElementById("root");
  if (!rootElement) throw new Error("Root element not found");

  createRoot(rootElement).render(
    <StrictMode>
      <WalletProvider>
        <App />
      </WalletProvider>
    </StrictMode>
  );
}

main();
