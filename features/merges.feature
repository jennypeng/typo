Feature: Merge Articles

  As a blog administrator
  In order to prevent two articles from having the same topic and information
  I want to be able to merge articles

  Background:

    Given the blog is set up

    Given the following users exist:
      | id | login | password | email         |
      |  1 | joe   | abc123   | joe@mail.com  |
      |  2 | john  | abc123   | john@mail.com |


    Given the following articles exist:
      | id | title    | author | user_id | body     | allow_comments | published_at        |
      | 1  | money    | joe    | 1       | good     | true           | 2014-12-11 10:00:59 |
      | 2  | drugz    | john   | 2       | bad      | true           | 2014-11-10 12:00:34 |

    Given the following comments exist:
      | id | title   | author | body    | article_id | user_id | created_at          |
      | 1  | money   | joe    | yeah    | 1          | 1       | 2014-12-11 10:00:59 |
      | 2  | drugz   | john   | lmao    | 2          | 2       | 2014-11-10 12:01:34 |

  Scenario: A non-admin cannot merge articles.
    Given I am logged in as "joe" with pass "abc123"
    And I am on the Edit Page of Article with id 1
    Then I should not see "Merge Articles"


  Scenario: When articles are merged, the merged article should contain the text of both previous articles.
    Given the articles with ids "1" and "2" were merged
    And I am on the home page
    Then I should see "money"
    When I follow "money"
    Then I should see "good"
    And I should see "bad"

  Scenario: When articles are merged, the merged article should have one author (either one of the authors of the original article).
    Given the articles with ids "1" and "2" were merged
    Then "joe" should be author of 1 articles
    And "john" should be author of 0 articles

  Scenario: Comments on each of the two original articles need to all carry over and point to the new, merged article.
    Given the articles with ids "1" and "2" were merged
    And I am on the home page
    Then I should see "money"
    When I follow "money"
    Then I should see "yeah"
    And I should see "lmao"

  Scenario: The title of the new article should be the title from either one of the merged articles.
    Given the articles with ids "1" and "2" were merged
    And I am on the home page
    Then I should see "money"
    And I should not see "drugz"