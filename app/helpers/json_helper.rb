module JsonHelper
  def json(object)
    Yajl::Encoder.encode(object).
      gsub("</script>", %{</script"+">}).
      html_safe
  end
end
