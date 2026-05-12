#Donde voy a cargar todos los archivos
defmodule Catalogo do

  def especie(pokemon_map, id) do
    case Map.get(pokemon_map, id) do

      nil -> {:error, :especie_no_encontrada}

      #Si lo halla crea un mapa donde una caractaristica es el id (nombre) y las caracteristicas del pokemon
      data -> {:ok, Map.put(data, "id", id)}
    end
  end

  def movimientos_por_tipo(moves_map, tipo) do
    Map.get(moves_map, tipo, [])
  end

  def todos_movimientos(moves_map) do
  moves_map
  |> Map.values()   #Lista de listas (omite las claves). Son varias listas dado que son varios tipos(elementos) de pokemon
  |> List.flatten() #Lo vuelve a una sola lista
  |> Enum.uniq_by(fn mov -> mov["nombre"] end) #Ningun nombre repetido, y sigue siendo una lista de tuplas (cada tupla es un movimiento)
  end
end
