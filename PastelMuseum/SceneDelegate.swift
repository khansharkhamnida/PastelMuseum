import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let exploreNav = createNavigationController(for: ExploreViewController())
        exploreNav.tabBarItem = UITabBarItem(
            title: "Explore",
            image: UIImage(systemName: "sparkles"),
            selectedImage: UIImage(systemName: "sparkles")
        )

        let swatchesNav = createNavigationController(for: PastelListViewController())
        swatchesNav.tabBarItem = UITabBarItem(
            title: "My Pastels",
            image: UIImage(systemName: "paintpalette"),
            selectedImage: UIImage(systemName: "paintpalette.fill")
        )

        let worksNav = createNavigationController(for: ArtworkListViewController())
        worksNav.tabBarItem = UITabBarItem(
            title: "My Works",
            image: UIImage(systemName: "photo.on.rectangle"),
            selectedImage: UIImage(systemName: "photo.on.rectangle.fill")
        )

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [exploreNav, swatchesNav, worksNav]
        styleTabBar(tabBarController.tabBar)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    private func createNavigationController(for rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        return navigationController
    }

    private func styleTabBar(_ tabBar: UITabBar) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBrown
        
        let normal = UIColor.white.withAlphaComponent(0.6)
        for itemAppearance in [appearance.stackedLayoutAppearance, appearance.inlineLayoutAppearance, appearance.compactInlineLayoutAppearance] {
            itemAppearance.normal.iconColor = normal
            itemAppearance.normal.titleTextAttributes = [.foregroundColor: normal]
            itemAppearance.selected.iconColor = .white
            itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
