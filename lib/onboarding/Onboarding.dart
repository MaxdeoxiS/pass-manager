import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatelessWidget {
  final PageController _pageController = PageController();

  Future<void> onOnboardingDone(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstLaunch', false);
    Navigator.pushReplacementNamed(context, "/passwords");
  }

  @override
  Widget build(BuildContext context) {
    return Provider<OnBoardState>(
      create: (_) => OnBoardState(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: OnBoard(
          pageController: _pageController,
          onSkip: () {
          },
          onDone: () {
            onOnboardingDone(context);
          },
          onBoardData: onBoardData,
          titleStyles: const TextStyle(
            color: Color(0xFF880100),
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.15,
          ),
          descriptionStyles: TextStyle(
            fontSize: 16,
            color: Colors.brown.shade300,
          ),
          pageIndicatorStyle: const PageIndicatorStyle(
            width: 100,
            inactiveColor: Color(0xFF880100),
            activeColor: Color(0xFF880100),
            inactiveSize: Size(8, 8),
            activeSize: Size(12, 12),
          ),
          skipButton: const Text(""),
          nextButton: Consumer<OnBoardState>(
            builder: (BuildContext context, OnBoardState state, Widget? child) {
              return InkWell(
                onTap: () => _onNextTap(state, context),
                child: Container(
                  width: 230,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [Color(0xFF880100), Colors.red.shade900],
                    ),
                  ),
                  child: Text(
                    state.isLastPage ? "C'est parti" : "Suivant",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onNextTap(OnBoardState onBoardState, BuildContext context) {
    if (!onBoardState.isLastPage) {
      _pageController.animateToPage(
        onBoardState.page + 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      onOnboardingDone(context);
    }
  }
}

final List<OnBoardModel> onBoardData = [
  const OnBoardModel(
    title: "Bienvenue dans SecuriPass",
    description: "Cette application vous permet de générer et stocker vos mots de passe de manière sécurisée, sur votre smartphone.",
    imgUrl: "assets/images/onboarding1.gif",
  ),
  const OnBoardModel(
    title: "100% sécurisé",
    description:
    "Vos mots de passe sont stockés sur votre téléphone, et nulle part ailleurs. \n \n Vos mots de passe sont chiffrés, et l'accès à l'application requiert une sécurité biométrique ou par code PIN.",
    imgUrl: 'assets/images/onboarding2.gif',
  ),
  const OnBoardModel(
    title: "Organisez vos mots de passe comme vous le voulez",
    description:
    "Couleur, icône, catégorie, commentaire, favoris, lien de modification... \n \n Gérez vos mots de passe comme bon vous semble, et retrouvez-les rapidement grâce aux différents filtres possibles",
    imgUrl: 'assets/images/onboarding3.gif',
  ),
  const OnBoardModel(
    title: "Toujours gratuit",
    description:
    "Développé par une seule personne sur son temps libre, SecuriPass restera toujours gratuite, sans pub et open-source, même lors des prochaines mises à jour: \n Gestion des cartes (CB, Visa, Cartes fidélité...) \n Gestion de notes \n Nouvelles fonctionnalités pour les mots de passe: paramétrer une date d'expiration, notificaiton, historique, analyse de la sécurité des mots de passe",
    imgUrl: 'assets/images/onboarding4.gif',
  ),
  const OnBoardModel(
    title: "Prêt ?",
    description:
    "Créez votre premier mot de passe et découvrez plus en détail les fonctionnalités de SecuriPass",
    imgUrl: 'assets/images/onboarding5.gif',
  ),
];