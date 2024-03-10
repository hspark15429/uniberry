

final List<Opportunity> dummyOpportunities = [
  Opportunity(
    category: 'Education',
    title: 'Online Programming Course',
    description: 'Join our comprehensive online programming course to enhance your skills.',
    imageUrls: [
      'https://example.com/image1.jpg',
      'https://example.com/image2.jpg',
    ],
    additionalInfo: 'Starts on: April 15, 2024. Duration: 3 months.',
  ),
  Opportunity(
    category: 'Volunteering',
    title: 'Community Clean-up Drive',
    description: 'Participate in our community clean-up drive and help us make our city cleaner.',
    imageUrls: [
      'https://kddi-h.assetsadobe3.com/is/image/content/dam/au-com/mobile/campaign/sale2402/images/mb_sale2402_bnr_01.jpg?scl=1&qlt=90',
      'https://example.com/image4.jpg',
    ],
    additionalInfo: 'Date: May 5, 2024. Location: Central Park.',
  ),
  Opportunity(
    category: 'Internship',
    title: 'Marketing Internship',
    description: 'Gain real-world experience with our 6-month marketing internship program.',
    imageUrls: [
      'https://example.com/image5.jpg',
    ],
    additionalInfo: 'Application deadline: March 31, 2024. Remote opportunity.',
  ),
  Opportunity(
    category: 'Scholarship',
    title: 'Undergraduate Scholarship Program',
    description: 'Apply for our undergraduate scholarship program and secure your future.',
    imageUrls: [],
    additionalInfo: 'Eligibility: High school seniors. Deadline: April 30, 2024.',
  ),
  Opportunity(
    category: 'Workshop',
    title: 'Digital Marketing Workshop',
    description: 'Enhance your digital marketing skills with our expert-led workshop.',
    imageUrls: [
      'https://example.com/image6.jpg',
    ],
    additionalInfo: 'Date: June 10, 2024. Location: Online.',
  ),
];

class Opportunity {
  final String category;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String? additionalInfo;

  Opportunity({
    required this.category,
    required this.title,
    required this.description,
    this.imageUrls = const [],
    this.additionalInfo,
  });
}
