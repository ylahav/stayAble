import 'package:flutter_test/flutter_test.dart';
import 'package:stayable/data/remote/rich_text.dart';

void main() {
  test('reads HTML strings as-is', () {
    expect(fieldToHtml('<p>Stand tall</p>'), '<p>Stand tall</p>');
  });

  test('converts lexical instructions to HTML', () {
    final html = lexicalToHtml({
      'root': {
        'type': 'root',
        'children': [
          {
            'type': 'paragraph',
            'children': [
              {'type': 'text', 'text': 'Stand tall', 'format': 1},
            ],
          },
          {
            'type': 'list',
            'listType': 'number',
            'children': [
              {
                'type': 'listitem',
                'children': [
                  {'type': 'text', 'text': 'Lift the knees'},
                ],
              },
            ],
          },
        ],
      },
    });
    expect(html, contains('<p><strong>Stand tall</strong></p>'));
    expect(html, contains('<ol><li>Lift the knees</li></ol>'));
  });
}
