import 'package:dio/dio.dart';
import 'package:gsy_github_app_flutter/model/TrendingRepoModel.dart';
import 'package:gsy_github_app_flutter/common/net/api.dart';
import 'package:gsy_github_app_flutter/common/net/code.dart';
import 'package:gsy_github_app_flutter/common/net/result_data.dart';

/**
 * 趋势数据解析
 * Created with guoshuyu
 * Date: 2018-07-16
 */
class GitHubTrending {
  fetchTrending(url) async {
    var res = await httpManager.netFetch(
        url, null, null, new Options(contentType: "text/plain; charset=utf-8"));
    if (res != null && res.result && res.data != null) {
      return new ResultData(
          TrendingUtil.htmlToRepo(res.data), true, Code.SUCCESS);
    } else {
      return res;
    }
  }
}

const TAGS = {
  "meta": {
    "start": '<span class="d-inline-block ml-0 mr-3"',
    "flag": '/svg>',
    "end": '</span>end'
  },
  "starCount": {
    "start": '<svg aria-label="star"',
    "flag": '/svg>',
    "end": '</a>'
  },
  "forkCount": {
    "start": '<svg aria-label="fork"',
    "flag": '/svg>',
    "end": '</a>'
  }
};

class TrendingUtil {
  static htmlToRepo(String responseData) {
    try {
      responseData = responseData.replaceAll(new RegExp('\n'), '');
    } catch (e) {}
    var repos = [];
    var splitWithH3 = responseData.split('<article');
    splitWithH3.removeAt(0);
    for (var i = 0; i < splitWithH3.length; i++) {
      TrendingRepoModel repo = TrendingRepoModel.empty();
      var html = splitWithH3[i];

      parseRepoBaseInfo(repo, html);

      String metaNoteContent =
          parseContentWithNote(html, 'class="f6 color-fg-muted mt-2">', '<\/div>') +
              "end";
      repo.meta = parseRepoLabelWithTag(repo, metaNoteContent, TAGS["meta"]);
      repo.starCount =
          parseRepoLabelWithTag(repo, metaNoteContent, TAGS["starCount"]);
      repo.forkCount =
          parseRepoLabelWithTag(repo, metaNoteContent, TAGS["forkCount"]);

      parseRepoLang(repo, metaNoteContent);
      parseRepoContributors(repo, metaNoteContent);
      repos.add(repo);
    }
    return repos;
  }

  static String parseContentWithNote(htmlStr, startFlag, endFlag) {
    var noteStar = htmlStr.indexOf(startFlag);
    if (noteStar == -1) {
      return '';
    } else {
      noteStar += startFlag.length;
    }

    var noteEnd = htmlStr.indexOf(endFlag, noteStar);
    String content = htmlStr.substring(noteStar, noteEnd);
    return trim(content);
  }


  static parseRepoBaseInfo(repo, htmlBaseInfo) {
    // var urlIndex = htmlBaseInfo.indexOf('<a href="') + '<a href="'.length;
    var urlList = htmlBaseInfo.split('<a href="');
    // print(urlList[2]);
    String url =
    urlList[2].substring(0, urlList[2].indexOf('\"'));
    repo.url = url.substring(0, url.lastIndexOf('\/'));
    repo.fullName = repo.url.substring(1, repo.url.length);
    if (repo.fullName != null && repo.fullName.indexOf('/') != -1) {
      repo.name = repo.fullName.split('/')[0];
      repo.reposName = repo.fullName.split('/')[1];
    }

    String? description = parseContentWithNote(
        htmlBaseInfo, '<p class="col-9 color-fg-muted my-1 pr-4">', '</p>');
    if (description != null) {
      String reg = "<g-emoji.*?>.+?</g-emoji>";
      RegExp tag = new RegExp(reg);
      Iterable<Match> tags = tag.allMatches(description);
      for (Match m in tags) {
        String match = m
            .group(0)!
            .replaceAll(new RegExp("<g-emoji.*?>"), "")
            .replaceAll(new RegExp("</g-emoji>"), "");
        description = description?.replaceAll(new RegExp(m.group(0)!), match);
      }
    }
    repo.description = description;
  }

  static parseRepoLabelWithTag(repo, noteContent, tag) {
    var startFlag;
    if (TAGS["starCount"] == tag || TAGS["forkCount"] == tag) {
      startFlag = tag["start"];
    } else {
      startFlag = tag["start"];
    }
    String content = parseContentWithNote(noteContent, startFlag, tag["end"]);
    if (tag["flag"] != null
        && content.indexOf(tag["flag"]) != -1
        && (content.indexOf(tag["flag"]) + tag["flag"].length <= content.length)) {
      if(TAGS["meta"] != tag){
      String metaContent = content.substring(
          (content.indexOf(tag["flag"]) + tag["flag"].length) as int,
          content.length);
      return trim(metaContent);
      }else{
        String metaContent = content.substring(
            (content.lastIndexOf(tag["flag"]) + tag["flag"].length) as int,
            content.length);
        return trim(metaContent);
      }
    } else {
      return trim(content);
    }
  }

  static parseRepoLang(repo, metaNoteContent) {
    var content = parseContentWithNote(
        metaNoteContent, 'programmingLanguage">', '</span>');
    repo.language = trim(content);
  }

  static parseRepoContributors(repo, htmlContributors) {
    htmlContributors =
        parseContentWithNote(htmlContributors, 'Built by', '</span>end');
    List<String> splitWitSemicolon = htmlContributors.split('<img class="avatar mb-1 avatar-user"');
    if (splitWitSemicolon.length > 1) {
      repo.contributorsUrl = splitWitSemicolon[0].substring(splitWitSemicolon[0].lastIndexOf("\/")+1, splitWitSemicolon[0].length - 3);
      splitWitSemicolon.removeAt(0);
    }
    repo.contributors = List<String>.empty(growable: true);
    for (int i = 0; i < splitWitSemicolon.length; i++) {
      String url = splitWitSemicolon[i];
      if (url.indexOf('http') != -1) {
        repo.contributors.add(parseContentWithNote(url, 'src="', '"'));
      }
    }

  }

  static trim(text) {
    if (text is String) {
      return text.trim();
    } else {
      return text.toString().trim();
    }
  }
}
