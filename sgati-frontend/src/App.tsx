import { useEffect, useState } from "react";
import { SuiClient, getFullnodeUrl } from "@mysten/sui.js/client";
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

const sui = new SuiClient({ url: getFullnodeUrl("mainnet") }); // Cambia a "testnet" si lo necesitas

function App() {
  const [activos, setActivos] = useState<any[]>([]);
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Reemplaza por la dirección del módulo y el struct
    const fetchActivos = async () => {
      try {
        // Ejemplo: busca objetos del tipo sgati_addr::sgati::Activo
        const objects = await sui.getOwnedObjects({
          owner: "0xc3289f98552fe58b67f8a250e9a4937603d07eef21af0fa04d90bc86470f6f1d", // Cambia por tu address
          filter: {
            StructType: "sgati_addr::sgati::Activo",
          },
        });
        setActivos(objects.data);
      } catch (error) {
        console.error("Error al consultar activos:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchActivos();
  }, []);

  return (
    <>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
      <div>
        <h1>Activos de TI en Sui</h1>
        {loading ? (
          <p>Cargando activos...</p>
        ) : (
          <ul>
            {activos.map((obj) => (
              <li key={obj.objectId}>
                <strong>ID:</strong> {obj.objectId}
              </li>
            ))}
          </ul>
        )}
      </div>
    </>
  )
}

export default App
