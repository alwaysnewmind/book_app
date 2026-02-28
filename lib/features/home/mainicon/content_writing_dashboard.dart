import 'package:book_app/providers/story_analyzer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentWritingDashboard extends StatefulWidget {
  const ContentWritingDashboard({Key? key}) : super(key: key);

  @override
  State<ContentWritingDashboard> createState() => _ContentWritingDashboardState();
}

class _ContentWritingDashboardState extends State<ContentWritingDashboard> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xffF3EEFF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xffE9E4FF), Color(0xffD6CCFF)]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Good Evening, Aryan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 20),
              const Text('Story Analyzer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
                child: Consumer<StoryAnalyzerProvider>(builder: (context, analyzer, _) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    TextField(
                      controller: _textController,
                      minLines: 4,
                      maxLines: 6,
                      decoration: const InputDecoration(hintText: 'Paste your story excerpt for AI analysis'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                      onPressed: analyzer.isAnalyzing ? null : () => analyzer.analyzeStory(_textController.text),
                      child: const Text('Analyze'),
                    ),
                    if (analyzer.isAnalyzing) const Padding(padding: EdgeInsets.only(top: 12), child: CircularProgressIndicator()),
                    if (analyzer.result != null) ...[
                      const SizedBox(height: 12),
                      Text('Grammar Score: ${analyzer.result!.grammarScore}'),
                      Text('Engagement Score: ${analyzer.result!.engagementScore}'),
                      const SizedBox(height: 6),
                      ...analyzer.result!.suggestions.map((s) => Text('• $s')),
                    ],
                  ]);
                }),
              ),
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.deepPurple, onPressed: () {}, child: const Icon(Icons.add)),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
