<!DOCTYPE html>
<html lang="{{ page.lang }}">
<head>
  {{ partial('partial/head') }}
</head>
<body>
  {{ partial('partial/header') }}
  <div id="container">
    {{ body }}
  </div>
</body>
<script src="https://cdn.jsdelivr.net/docsearch.js/2/docsearch.min.js"></script>
<script> 
docsearch({
  apiKey: '05ed1f07c3babecff84b3d15c4e5fd63',
  indexName: 'fusionlab',
  inputSelector: '#search-query',
  debug: true // Set debug to true if you want to inspect the dropdown
});
</script>
</html>