defmodule ServidorJuego do

  use GenServer

  alias Modelos.Entrenador
  alias Modelos.SobrePendiente

  def main do
    Util.imprimir_mensaje("Servidor de Programa Iniciando...")
    {:ok, _} = Node.start(:servidor@localhost, :shortnames)
    Node.set_cookie(:pokemon)
    # Se ejecuta el GenServer (proceso con un estado interno)
    {:ok, _} = start_link()
    Util.imprimir_mensaje("¡El servidor se ha iniciado!")
    # Se bloquea el proceso principal para que se ejecute de forma ininterrumpida
    Process.sleep(:infinity)
  end


  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end


  @impl true
  def init(_) do
    #Función de Meli de Leer
    {:ok, cargar_datos()}
  end

  #Login
  def handle_call({:login, usuario, clave}, _from, estado) do
    case Map.get(estado, usuario) do
      nil ->
        # Crear usuario
        nuevo = %Entrenador{
          usuario: usuario,
          clave: clave,
          victorias: 0,
          monedas_actuales: 500,
          monedas_acumuladas: 500,
          inventario: [],
          sobres_pendientes: [
            %SobrePendiente{
              id: UUID.uuid4(),
              tipo: "basico"
              }
            ],
          equipos: []
        }

        nuevo_estado = Map.put(estado, usuario, nuevo)
        guardar_datos(nuevo_estado) #Función Meli de Guardar

        {:reply, {:ok, nuevo}, nuevo_estado}

      existente ->
        if existente.clave == clave do
          {:reply, {:ok, existente}, estado}
        else
          {:reply, {:error, :clave_incorrecta}, estado}
        end
    end
  end

  #-------------------- Perfil ---------------------
  def handle_call({:ver_perfil, usuario}, _from, estado) do
    entrenador = Map.get(estado, usuario)
    respuesta = GestionPerfil.ver_perfil(entrenador)
    {:reply, respuesta, estado}
  end

  def handle_call({:ver_inventario, usuario}, _from, estado) do
    entrenador = Map.get(estado, usuario)
    respuesta = GestionPerfil.ver_inventario(entrenador)
    {:reply, respuesta, estado}
  end


  # COMPRAR SOBRE
  def handle_call({:comprar_sobre, usuario, tipo}, _from, estado) do
    entrenador = Map.get(estado, usuario)

    case GestionTienda.comprar_sobre(entrenador, tipo) do
      {:ok, actualizado} ->
        nuevo_estado = Map.put(estado, usuario, actualizado)
        guardar_datos(nuevo_estado)
        {:reply, :ok, nuevo_estado}

      {:error, msg} ->
        {:reply, {:error, msg}, estado}
    end
  end
end
