defmodule Justrunit.S3 do
  import Req
  import ReqS3

  def new_req(options \\ []) when is_list(options) do
    Req.new(base_url: "s3://justrunit", retry: :transient)
    |> ReqS3.attach()
    |> Req.merge(options)
  end

  def put_object(key, content, opts \\ []) do
    put_if_exists = Keyword.get(opts, :put_if_exists, false)

    if put_if_exists && object_exists?(key) do
      {:error, :already_exists}
    else
      req = new_req()

      full_url = "#{req.options[:base_url]}/#{key}"
      IO.puts("Debug: Request URL: #{full_url}")

      case Req.put!(req, url: key, body: content) do
        %Req.Response{status: status} when status in 200..299 ->
          {:ok, :created}

        response ->
          IO.inspect(response)
          {:error, response}
      end
    end
  end

  def read_object(key) do
    req = new_req()

    case Req.get!(req, url: key) do
      %Req.Response{status: 200, body: body} -> {:ok, body}
      response -> {:error, response}
    end
  end

  def delete_object(s3_key) do
    req = new_req()

    case Req.delete!(req, url: s3_key) do
      %Req.Response{status: status} when status in 200..299 ->
        {:ok, :deleted}

      response ->
        {:error, response}
    end
  end

  def list_objects(prefix) do
    req = new_req()

    case Req.get!(req, params: [prefix: prefix]) do
      %Req.Response{status: 200, body: body} -> {:ok, body}
      response -> {:error, response}
    end
  end

  def object_exists?(s3_key) do
    req = new_req()

    case Req.head!(req, url: s3_key) do
      %Req.Response{status: 200} -> true
      _ -> false
    end
  end

  defp handle_aws_response({:ok, %{status_code: 200} = response}), do: {:ok, response}

  defp handle_aws_response({:ok, %{status_code: status_code}}),
    do: {:error, "HTTP Status: #{status_code}"}

  defp handle_aws_response({:error, {:http_error, status_code, body}}),
    do: {:error, "HTTP Error: #{status_code}, #{body}"}

  defp handle_aws_response({:error, reason}), do: {:error, reason}
end
