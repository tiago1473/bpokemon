defmodule GestionPerfil do

  def ver_perfil(entrenador) do
    """
    === Perfil de #{entrenador.usuario} ===
    Monedas: #{entrenador.monedas_actuales}
    Sobres: #{length(entrenador.sobres_pendientes)}
    Pokémon en Inventario: #{length(entrenador.inventario)}
    """
  end

  def ver_inventario(entrenador) do

  end


end
