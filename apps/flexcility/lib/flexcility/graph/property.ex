  defprotocol Flexcility.Graph.Property do
    @doc """
      Returns a value in single quotes if it's a string and returns other
      values as is (supports integers, floats and booleans for now)
    """
    @fallback_to_any true
    def property_from_value(value)
  end

  defimpl Flexcility.Graph.Property, for: BitString do
    def property_from_value(string_value), do: "'#{string_value}'"
  end

  defimpl Flexcility.Graph.Property, for: Integer do
    def property_from_value(integer_value), do: integer_value
  end

  defimpl Flexcility.Graph.Property, for: Float do
    def property_from_value(float_value), do: float_value
  end

  defimpl Flexcility.Graph.Property, for: Boolean do
    def property_from_value(boolean_value), do: boolean_value
  end

  defimpl Flexcility.Graph.Property, for: Any do
    def property_from_value(_value), do: "null"
  end
