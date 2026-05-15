defmodule MenuPrincipal do

  @nodo_servidor :servidor@localhost

  def main do
    # Se configura el nodo para habilitar la comunicación remota
    Util.imprimir_mensaje("Iniciando el nodo cliente....")
    {:ok, _} = Node.start(:entrenador@localhost, :shortnames)
    Node.set_cookie(:pokemon)
    IO.puts("El nodo Entrenador se ha iniciado!")

    #Intenta conectarse al nodo servidor
    case Node.connect(@nodo_servidor) do
      true ->
        iniciar()
      false ->
        Util.imprimir_mensaje("No se puede establecer la conexión con el servidor")
    end
  end

  def iniciar do
    usuario = login()
    loop_principal(usuario)
  end

  defp login do
    usuario = Util.leer("Usuario: ", :string)
    clave = Util.leer("Clave: ", :string)

    case Genserver.call({ServidorJuego, @nodo_servidor}, {:login, usuario, clave}) do
      {:ok, user} ->
        user.usuario #Retorno al usuario para seguir trabajando con él
        Util.imprimir_mensaje("Ingreso Correcto de Usuario")

      {:error, :clave_incorrecta} ->
        Util.imprimir_error("Clave incorrecta")
        login()
    end
  end

  defp loop_principal(usuario) do
    Util.imprimir_mensaje("""

    ------------- MENÚ PRINCIPAL -------------
    1. Perfil, Inventario y Clasificación
    2. Tienda y Sobres
    3. Intercambio Pokémon
    4. Equipos Pokémon
    5. Salas de batalla
    6. Salir
    ------------------------------------------

    """)

    opcion = Util.leer("Ingrese una opción: ", :integer)

    case opcion do
      1 ->
        MenuPerfil.mostrar(usuario)
        loop_principal(usuario)
      2 ->
        MenuTienda.mostrar(usuario)
        loop_principal(usuario)
      3 ->
        MenuIntercambio.mostrar(usuario)
        loop_principal(usuario)
      4 ->
        MenuEquipos.mostrar(usuario)
        loop_principal(usuario)
      5 ->
        MenuSalasBatalla.mostrar(usuario)
        loop_principal(usuario)
      6 ->
        Util.imprimir_mensaje("Saliendo......")
      _ ->
        Util.imprimir_error("Opción inválida. Intente Nuevamente")
        loop_principal(usuario)
    end
  end

end
