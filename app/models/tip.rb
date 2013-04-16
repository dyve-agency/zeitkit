class Tip
  def self.tips
    [
      "Get a list of your recent git commits, copy paste into a new worklog: git log --reverse --format=%B --max-count=20 | sed '/^$/d' | sed 's/^/* /'",
      "zlog for pure awesomness. Edit your .bashrc/.zshrc. Paste: alias zlog=\"git log --reverse --format=%B --max-count=20 | sed '/^$/d' | sed 's/^/* /'\"",
      "Fill in your worklogs as detailed as possible. This way your clients have no bad feelings.",
      "The ninja workflow: 1) Start a new worklog, 2) Add some commits, 3) Stop the timer. 4) Save.",
      "If you lose your last worklog, no problem. You can restore unsaved changes.",
      "Your invoices should be paid within 15 days, if not, ask the client what's wrong.",
      "Charge your clients more for rush jobs.",
      "Keep track of expenses and bill them with your monthly invoices.",
      "If you have recurring expenses you may want to create a product. We resell our servers that way.",
      "Products can be created with an upcharge. This is awesome when you are reselling products to your client.",
      "Markdown is powerful and can be nicely written in text editors. We love markdown and you can use it for invoices, worklogs and more.",
      "If you are new to markdown, have a look at <a href='http://daringfireball.net/projects/markdown/syntax'>this guide</a>",
      "Notes are awesome for keeping track on your TODOS. We log our meetings including TODOS.",
      "You can share important notes with your client via a unique share link.",
      "Filter worklogs to see what you got done in a specific time period.",
      "Sometimes required for corporate clients: Worklogs can be exported as .CSV",
      "Ideas/Feedback? Email us at <a href='mailto:info@zeitkit.com'>info@zeitkit.com</a>."
    ]
  end

  def self.random_tip
    self.tips[rand(0..(self.tips.length - 1))]
  end
end
