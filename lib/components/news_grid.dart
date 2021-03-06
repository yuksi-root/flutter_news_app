import 'package:flutter/material.dart';
import 'package:flutter_news_app_with_api/components/news_image.dart';
import 'package:flutter_news_app_with_api/core/constants/navigation_constants.dart';
import 'package:flutter_news_app_with_api/core/navigation/navigation_service.dart';
import 'package:flutter_news_app_with_api/core/notifier/tabbar_navigation_notifier.dart';
import 'package:flutter_news_app_with_api/models/news_categories.dart';
import 'package:flutter_news_app_with_api/models/news_country.dart';
import 'package:flutter_news_app_with_api/view_models/news_article_list_view_model.dart';
import 'package:flutter_news_app_with_api/view_models/news_article_view_model.dart';
import 'package:flutter_news_app_with_api/core/extension/context_extension.dart';
import 'package:flutter_news_app_with_api/core/extension/string_extension.dart';
import 'package:flutter_news_app_with_api/view_models/news_country_settings_view_model.dart';
import 'package:provider/provider.dart';

class NewsGrid extends StatelessWidget {
  final NavigationService navigation = NavigationService.instance;
  final List<NewsArticleViewModel> articles;
  final List<NewsCategory>? categories;
  final List<NewsCountry>? countries;

  NewsGrid({Key? key, required this.articles, this.categories, this.countries})
      : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  void _showNewsArticleDetails(context, article) => navigation.navigateToPage(
      path: NavigationConstants.NEWS_DETAILS_WIEW, data: article);

  @override
  Widget build(BuildContext context) {
    final listViewModel = Provider.of<NewsArticleListViewModel>(context);
    final tabbarProv = Provider.of<TabbarNavigationProvider>(context);
    final countrySettingsModel =
        Provider.of<NewsCountrySettingsViewModel>(context);
    return RefreshIndicator(
      color: Colors.greenAccent,
      key: _refreshIndicatorKey,
      onRefresh: () => listViewModel.topHeadlinesCategoryWithCountry(
          countries!
              .map((country) => country.countryCode!)
              .elementAt(countrySettingsModel.getCountryIndex),
          categories!
              .map((categori) => categori.categoryCode)
              .elementAt(tabbarProv.currentIndex)),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, childAspectRatio: 2, mainAxisSpacing: 5),
        itemBuilder: (context, index) {
          final article = articles[index];
          return GestureDetector(
            onTap: () {
              _showNewsArticleDetails(context, article);
            },
            child: GridTile(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.dynamicWidth(0.0277),
                    vertical: context.dynamicHeight(0.001)),
                child: Stack(children: [
                  NewsImage(
                    imageUrl: article.imageUrl,
                    imageRadius: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.dynamicWidth(0.0277),
                          vertical: context.dynamicHeight(0.0080),
                        ),
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xffbdc3c7),
                                          Color(0xccbdc3c7)
                                        ],
                                        tileMode: TileMode.clamp)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: context.dynamicWidth(0.01),
                                      vertical: 0),
                                  child: Text(
                                      categories!
                                          .map((categori) => categori
                                              .categoryName
                                              .toString()
                                              .locale)
                                          .elementAt(tabbarProv.currentIndex),
                                      style: TextStyle(
                                          fontSize:
                                              context.dynamicHeight(0.025),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.1,
                                          color: Colors.white),
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xff2c3e50),
                                        Color(0xcc2c3e50)
                                      ],
                                      tileMode: TileMode.clamp),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.dynamicWidth(0.01),
                                    vertical: context.dynamicHeight(0.0001),
                                  ),
                                  child: Text(
                                      article.source.contains(".")
                                          ? article.source
                                              .split(".")
                                              .elementAt(0)
                                          : article.source,
                                      style: TextStyle(
                                          fontSize:
                                              context.dynamicHeight(0.025),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.1,
                                          color: Colors.white),
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x40000080).withOpacity(0.15),
                              blurRadius: 0.01,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.dynamicWidth(0.0277),
                              vertical: context.dynamicHeight(0.0253)),
                          child: Text(article.title,
                              style: TextStyle(
                                  fontSize: context.dynamicHeight(0.025),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.1,
                                  color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          );
        },
        itemCount: articles.length,
      ),
    );
  }
}
