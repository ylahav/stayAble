bool looksLikeHtml(String raw) =>
    RegExp(r'<[a-zA-Z][^>]*>').hasMatch(raw);

String fieldToHtml(Object? raw) {
  if (raw is String) return raw;
  if (raw is Map) return lexicalToHtml(raw);
  return '';
}

String lexicalToHtml(Map<Object?, Object?> node) {
  final root = node['root'];
  if (root is Map) return _nodeToHtml(root);
  return _nodeToHtml(node);
}

String _escape(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

String _nodeToHtml(Object? node) {
  if (node is! Map) return '';
  final type = node['type'] as String? ?? '';
  final children = node['children'];
  final inner = children is List ? children.map(_nodeToHtml).join() : '';
  switch (type) {
    case 'text':
      var out = _escape(node['text'] as String? ?? '');
      final format = node['format'];
      final flags = format is int ? format : 0;
      if (flags & 1 != 0) out = '<strong>$out</strong>';
      if (flags & 2 != 0) out = '<em>$out</em>';
      if (flags & 4 != 0) out = '<s>$out</s>';
      if (flags & 8 != 0) out = '<u>$out</u>';
      if (flags & 16 != 0) out = '<code>$out</code>';
      return out;
    case 'linebreak':
      return '<br>';
    case 'paragraph':
      return '<p>$inner</p>';
    case 'heading':
      final tag = node['tag'] as String? ?? 'h2';
      return '<$tag>$inner</$tag>';
    case 'list':
      final tag = node['listType'] == 'number' ? 'ol' : 'ul';
      return '<$tag>$inner</$tag>';
    case 'listitem':
      return '<li>$inner</li>';
    case 'quote':
      return '<blockquote>$inner</blockquote>';
    case 'link':
      final fields = node['fields'];
      final url = fields is Map ? fields['url'] : node['url'];
      return '<a href="${_escape(url?.toString() ?? '')}">$inner</a>';
    case 'root':
      return inner;
    default:
      return inner;
  }
}
