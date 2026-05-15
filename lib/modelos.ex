defmodule Modelos do

  #---------------------Pokemon------------------------------------------------
  defmodule PokemonInstancia do
    @enforce_keys [:id, :especie, :dueno_original, :rareza, :ataque, :defensa, :velocidad, :movimientos]
    defstruct [:id, :especie, :dueno_original, :rareza, :ataque, :defensa, :velocidad, :movimientos]

    def salud_maxima, do: 100

  end

  #---------------------Movimiento------------------------------------------------
  defmodule Movimiento do
    defstruct [:nombre, :tipo, :poder]
  end

  #---------------------SobrePendiente------------------------------------------------
  defmodule SobrePendiente do
    defstruct [:id, :tipo]
  end

  #---------------------Entrenador------------------------------------------------
  defmodule Entrenador do
    defstruct [
      :usuario,
      :clave,
      :victorias,
      :monedas_actuales,
      :monedas_acumuladas,
      inventario: [],
      sobres_pendientes: [],
      equipos: []
    ]

  end
end
