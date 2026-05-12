defmodule MotorCombate do

  #Calculo del daño según sección 7.6. `factor_aleatorio` entre 0.85 y 1.0 si no se pasa (producción).

  def calcular_dano(
        poder_movimiento,
        ataque_atacante,
        defensa_defensor,
        tipos_defensor_especie,
        tipo_movimiento, #El del atacante
        tipos_atacante_especie,
        factor_aleatorio \\ nil
      ) do
    factor = factor_aleatorio || :rand.uniform() * 0.15 + 0.85 #valor entre 0.85 y 1.0

    #Efectividad según tipo de movimiento y tipo de defensor
    efectividad = Tipos.modificador_movimiento_vs_defensor(tipo_movimiento, tipos_defensor_especie)

    #STAB(bonificación por ataque del mismo tipo), es decir, si mi pokemon es tipo fuego y mi ataque es tipo fuego, recibo bonificación
    stab = if Tipos.stab?(tipo_movimiento, tipos_atacante_especie), do: 1.5, else: 1.0

    #Formula de Proyecto
    dano_base =
      trunc((poder_movimiento * (ataque_atacante / defensa_defensor)) / 5 + 2)

    #Formula de Proyecto
    dano_final = trunc(dano_base * efectividad * stab * factor)

    #El proyecto dice que Daño mínimo por ataque exitoso. Entonces elijo el mayor valor
    max(1, dano_final)
  end

  #Orden de la acción por velocidad
  def orden_por_velocidad({nombre_a, vel_a}, {nombre_b, vel_b}) do
    cond do

      vel_a > vel_b -> [nombre_a, nombre_b] #Lista con orden de ataque
      vel_b > vel_a -> [nombre_b, nombre_a]
      #Caso velocidades iguales, (se sortea)
      true -> if(:rand.uniform(2) == 1, do: [nombre_a, nombre_b], else: [nombre_b, nombre_a])
    end
  end
end

defmodule Tipos do
  #Efectividad mínima requerida (sección 3.3)."

  @fuerte %{
    "Fuego" => ["Planta", "Hielo", "Bicho"],
    "Agua" => ["Fuego", "Roca", "Tierra"],
    "Planta" => ["Agua", "Roca", "Tierra"],
    "Eléctrico" => ["Agua", "Volador"],
    "Roca" => ["Fuego", "Hielo", "Volador", "Bicho"]
  }

  def modificador_movimiento_vs_defensor(tipo_movimiento, tipos_defensor) do
    Enum.reduce(tipos_defensor, 1.0, fn t_def, acc ->
      acc * modificador_uno(tipo_movimiento, t_def)
    end)
  end

  defp modificador_uno(t_mov, t_def) do
    cond do
      fuerte?(t_mov, t_def) -> 2.0
      fuerte?(t_def, t_mov) -> 0.5
      true -> 1.0
    end
  end

  defp fuerte?(atacante, defensor) do
    case Map.get(@fuerte, atacante) do #Hallo la lista de los "tipos" sobre los que es fuerte ese movimiento
      nil -> false
      lista -> defensor in lista       #Si dentro de esa lista está el tipo del defensor, arroja true
    end
  end

  def stab?(tipo_movimiento, tipos_atacante) do
    tipo_movimiento in tipos_atacante
  end
end
