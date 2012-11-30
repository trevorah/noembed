package Noembed::Source::XKCD;

use parent 'Noembed::Source';

use Web::Scraper;

sub prepare_source {
  my $self = shift;

  $self->{scraper} = scraper {
    process '#comic > img', title => '@title';
    process '#comic > img', alt => '@alt';
    process '#comic > img', src => '@src';
  };
}

sub provider_name { "XKCD" }
sub patterns { 'http://(?:www\.)?xkcd\.com/\d+/?' }

sub serialize {
  my ($self, $body) = @_;

  my $data = $self->{scraper}->scrape($body);

  return {
    title => $data->{alt},
    html  => $self->render($data),
  }
}

1;
