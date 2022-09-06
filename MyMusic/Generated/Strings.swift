// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Account
  internal static let accountLabel = L10n.tr("Localizable", "account_label", fallback: "Account")
  /// Cancel
  internal static let buttonCancel = L10n.tr("Localizable", "button_cancel", fallback: "Cancel")
  /// Sign out
  internal static let buttonSignOut = L10n.tr("Localizable", "button_sign_out", fallback: "Sign out")
  /// Could not get data
  internal static let couldNotGetDataLabel = L10n.tr("Localizable", "could_not_get_data_label", fallback: "Could not get data")
  /// Country
  internal static let countryLabel = L10n.tr("Localizable", "country_label", fallback: "Country")
  /// Are you sure to sign out?
  internal static let descriptionLabel = L10n.tr("Localizable", "description_label", fallback: "Are you sure to sign out?")
  /// Followers
  internal static let followerCountLabel = L10n.tr("Localizable", "follower_count_label", fallback: "Followers")
  /// Name
  internal static let fullnameLabel = L10n.tr("Localizable", "fullname_label", fallback: "Name")
  /// Product
  internal static let productLabel = L10n.tr("Localizable", "product_label", fallback: "Product")
  /// Profile
  internal static let profileLabel = L10n.tr("Localizable", "profile_label", fallback: "Profile")
  /// Sign out
  internal static let titleAccountLabel = L10n.tr("Localizable", "title_account_label", fallback: "Sign out")
  /// Sign in
  internal static let titleAuthVCHeader = L10n.tr("Localizable", "title_authVC_header", fallback: "Sign in")
  /// Browse
  internal static let titleHomePage = L10n.tr("Localizable", "title_home_page", fallback: "Browse")
  /// Home
  internal static let titleHomeTabbar = L10n.tr("Localizable", "title_home_tabbar", fallback: "Home")
  /// Library
  internal static let titleLibraryPage = L10n.tr("Localizable", "title_library_page", fallback: "Library")
  /// Login
  internal static let titleLoginVCHeader = L10n.tr("Localizable", "title_loginVC_header", fallback: "Login")
  /// View Your Profile
  internal static let titleProfileLabel = L10n.tr("Localizable", "title_profile_label", fallback: "View Your Profile")
  /// Profile
  internal static let titleProfileVCHeader = L10n.tr("Localizable", "title_profileVC_header", fallback: "Profile")
  /// Search
  internal static let titleSearchPage = L10n.tr("Localizable", "title_search_page", fallback: "Search")
  /// Settings
  internal static let titleSettingsVCHeader = L10n.tr("Localizable", "title_settingsVC_header", fallback: "Settings")
  /// Sign out
  internal static let titleSignOut = L10n.tr("Localizable", "title_sign_out", fallback: "Sign out")
  /// Localizable.strings
  ///   MyMusic
  /// 
  ///   Created by Ismayil Ismayilov on 02.09.22.
  internal static let titleWelcomePage = L10n.tr("Localizable", "title_welcome_page", fallback: "My Music")
  /// Sign in with Spotify
  internal static let titleWelcomeVCSigninLabel = L10n.tr("Localizable", "title_welcomeVC_signin_label", fallback: "Sign in with Spotify")
  /// User ID
  internal static let userIDLabel = L10n.tr("Localizable", "userID_label", fallback: "User ID")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
