### Fix: Correctly display cover images for categories and tags pages

#### Problem Description

Currently, the cover images set by `category_img` and `tag_img` in `_config.yml` do not apply to the main `/categories/` and `/tags/` pages. They only work if a `default_top_img` is set.

#### Why This is Important

This prevents users from setting specific cover images for these important archive pages, affecting the site's visual consistency and customization options.

#### How to Reproduce

1.  Set a path for `category_img` (e.g., `/images/website/categories.png`) in `themes/butterfly/_config.yml`.
2.  Ensure `default_top_img` is either not set or commented out.
3.  Navigate to the `/categories/` page on your Hexo site.
4.  Observe that no cover image is displayed for the categories page. (Repeat for `tag_img` and `/tags/` page).

#### Solution

This PR modifies `themes/butterfly/layout/includes/header/index.pug` to add a specific check for `page.type === 'categories'` and `page.type === 'tags'` within the `'page'` case. This ensures that the correct theme configuration (`theme.category_img` or `theme.tag_img`) is used for these pages, aligning the behavior with user expectations and allowing proper customization.
