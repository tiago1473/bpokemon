defmodule MenuPerfil do

  def mostrar(usuario) do
    loop(usuario)
  end

  defp loop(usuario) do
    Util.imprimir_mensaje("""

    -------- PERFIL --------
    1. Ver perfil
    2. Ver inventario
    3. Listar equipos
    4. Clasificación
    5. Volver

    """)

    opcion = Util.leer("Ingrese una opción: ", :integer)

    case opcion do
      1 ->
        ver_perfil(usuario)
        loop(usuario)
      2 ->
        ver_inventario(usuario)
        loop(usuario)
      3 ->
         GestionPerfil.listar_equipos(usuario)
        loop(usuario)
      4 ->
         GestionPerfil.generar_clasificacion()
        loop(usuario)
      5 ->
        :ok  #Salida del Menú
      _ ->
        Util.imprimir_error("Opción inválida. Intente nuevamente")
        loop(usuario)
    end
  end

   def ver_perfil(usuario) do
    case Genserver.call({ServidorJuego, @nodo_servidor}, {:ver_perfil, usuario}) do
      perfil -> Util.imprimir_mensaje(perfil)
      nil -> Util.imprimir_error("Usuario No Encontrado")
    end
  end

  def ver_inventario(usuario) do
    
  end

end

defmodule MenuTienda do

  def mostrar(usuario) do
    loop(usuario)
  end

  defp loop(usuario) do
    Util.imprimir_mensaje("""

    ------ TIENDA ------
    1. Ver tienda
    2. Comprar sobre
    3. Abrir sobre
    4. Volver
    """)

    opcion = Util.leer("Ingrese una opción: ", :integer)

    case opcion do
      1 ->
        GestionTienda.ver_tienda()
        loop(usuario)
      2 ->
        GestionTienda.comprar_sobre(usuario)
        loop(usuario)
      3 ->
        GestionTienda.abrir_sobre(usuario)
        loop(usuario)
      4 ->
        :ok
      _ ->
        Util.imprimir_error("Opción inválida. Intente nuevamente")
        loop(usuario)
      end
  end
end
